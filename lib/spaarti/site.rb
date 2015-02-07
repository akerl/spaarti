require 'cymbal'
require 'octoauth'
require 'octokit'
require 'pathname'

##
# Main Spaarti code, defines defaults and Site object
module Spaarti
  DEFAULT_OPTIONS = {
    base_path: './',
    auth_file: :default,
    config_file: '~/.spaarti.yml',
    exclude: [],
    format: '%{full_name}',
    git_config: [],
    quiet: false,
    purge: false
  }

  ##
  # Site object, represents a group of repos
  class Site
    def initialize(params = {})
      if params[:config_file] && !File.exist?(params[:config_file])
        fail 'Config file does not exist'
      end
      @options = DEFAULT_OPTIONS.dup.merge params
      load_config
    end

    def sync!
      Dir.chdir(@options[:base_path]) do
        repos.each(&:sync!)
        purge! if @options[:purge]
      end
    end

    def purge!
      Dir.glob('**/.git').each do |git_dir|
        repo = Pathname.new(git_dir).dirname
        next if repos.any? { |x| x.parent_of(repo) }
        Pathname.rmtree repo
      end
    end

    private

    def load_config
      return unless File.exist?(@options[:config_file])
      config = File.open(@options[:config_file]) { |fh| YAML.load fh.read }
      @options.merge! Cymbal.symbolize(config)
    end

    def client
      @client ||= Octokit::Client.new(
        access_token: auth.token,
        auto_paginate: true,
        default_media_type: 'application/vnd.github.moondragon+json'
      )
    end

    def auth
      @auth ||= Octoauth.new(
        note: 'spaarti',
        file: @options[:auth_file],
        autosave: true
      )
    end

    def repos
      @repos ||= client.repos.map do |data|
        next if excluded(data.name) || excluded(data.full_name)
        Repo.new data.to_h, client, @options.subset(:format, :git_config)
      end
    end

    def excluded(string)
      @options[:exclude].any? { |x| string.match(x) }
    end
  end
end

##
# Add .subset to Hash for selecting a subhash
class Hash
  def subset(*keys)
    select { |k| keys.include? k }
  end
end
