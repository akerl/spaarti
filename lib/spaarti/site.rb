require 'cymbal'
require 'octoauth'
require 'octokit'
require 'pathname'
require 'fileutils'

##
# Main Spaarti code, defines defaults and Site object
module Spaarti
  DEFAULT_OPTIONS = {
    base_path: './',
    auth_file: :default,
    config_file: File.expand_path('~/.spaarti.yml'),
    exclude: [],
    format: '%{full_name}',
    git_config: {},
    quiet: false,
    purge: false,
    url_type: 'ssh',
    api_endpoint: nil
  }.freeze

  ##
  # Site object, represents a group of repos
  class Site
    def initialize(params = {})
      @options = DEFAULT_OPTIONS.dup.merge params
      load_config(params.include?(:config_file))
      return unless @options[:auth_file].is_a? String
      @options[:auth_file] = File.expand_path(@options[:auth_file])
    end

    def sync!
      Dir.chdir(File.expand_path(@options[:base_path])) do
        repos.each(&:sync!)
        purge! if @options[:purge]
      end
    end

    def purge!
      Dir.glob('**/.git').each do |git_dir|
        repo = Pathname.new(git_dir).dirname
        next if repos.any? { |x| x.parent_of(repo) }
        FileUtils.rmtree repo
      end
    end

    private

    def load_config(required = false)
      @options[:config_file] = File.expand_path @options[:config_file]
      unless File.exist?(@options[:config_file])
        raise 'Conf file does not exist' if required
        return
      end
      config = File.open(@options[:config_file]) { |fh| YAML.load fh.read }
      @options.merge! Cymbal.symbolize(config)
    end

    def client
      @client ||= Octokit::Client.new(
        access_token: auth.token,
        auto_paginate: true,
        default_media_type: 'application/vnd.github.moondragon+json',
        api_endpoint: @options[:api_endpoint]
      )
    end

    def auth
      @auth ||= Octoauth.new(
        note: 'spaarti',
        file: @options[:auth_file],
        autosave: true,
        api_endpoint: @options[:api_endpoint]
      )
    end

    def repos
      @repos ||= client.repos.map do |data|
        next if excluded(data)
        Repo.new data.to_h, client, @options
      end.compact
    end

    def excluded(data)
      @options[:exclude].any? do |key, patterns|
        patterns.any? { |pattern| data[key].match pattern }
      end
    end
  end
end
