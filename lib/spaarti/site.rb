require 'cymbal'

##
# Main Spaarti code, defines defaults and Site object
module Spaarti
  DEFAULT_CONFIG_PATH = '~/.spaarti.yml'

  DEFAULT_CONFIG = {
    base_path: './',
    auth_file: nil,
    exclude: [],
    format: '%{user}/%{repo}',
    git_config: []
  }

  ##
  # Site object, represents a group of repos with a config
  class Site
    def initialize(options)
      @config = load_config(options[:config])
    end

    private

    def load_config(path)
      fail "File does not exist: #{path}" if path && !File.exist?(path)
      path ||= DEFAULT_CONFIG_PATH
      config = DEFAULT_CONFIG.dup
      return config unless File.exist?(path)
      file = File.open(path) { |fh| YAML.load fh.read }
      config.merge! Cymbal.symbolize(file)
    end
  end
end
