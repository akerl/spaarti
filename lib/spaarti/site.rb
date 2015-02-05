require 'cymbal'
require 'octoauth'
require 'octokit'
require 'pathname'

##
# Main Spaarti code, defines defaults and Site object
module Spaarti
  DEFAULT_CONFIG_PATH = '~/.spaarti.yml'

  DEFAULT_CONFIG = {
    base_path: './',
    auth_file: :default,
    exclude: [],
    format: '%{full_name}',
    git_config: []
  }

  ##
  # Site object, represents a group of repos with a config
  class Site
    def initialize(options)
      @options = options
      if options[:config] && !File.exist?(options[:config])
        fail 'Config file does not exist'
      end
      @options[:config] ||= DEFAULT_CONFIG_PATH
    end

    def sync!
      Dir.chdir(config[:base_path]) do
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

    def config
      @config ||= build_config
    end

    def build_config
      path = @options[:config]
      config = DEFAULT_CONFIG.dup
      return config unless File.exist?(path)
      file = File.open(path) { |fh| YAML.load fh.read }
      return nest if file.is_a? Array
      config.merge! Cymbal.symbolize(file)
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
        file: config[:auth_file],
        autosave: true
      )
    end

    def repos
      @repos ||= client.repos.map do |data|
        next if excluded(data.name) || excluded(data.full_name)
        Repo.new data.to_h, client, config.subset(:format, :git_config)
      end
    end

    def excluded(string)
      config[:exclude].any? { |x| string.match(x) }
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
