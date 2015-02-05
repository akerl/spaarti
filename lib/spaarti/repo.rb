require 'rugged'

module Spaarti
  ##
  # Repo object, handles individual repo syncing and state
  class Repo
    def initialize(data, client, params)
      @raw = data
      @client = client
      @params = params
      @path = @params[:format] % @raw
    end

    def sync!
      return found if Dir.exist?(@path)
      repo = clone
      config repo
      add_upstream if @raw[:fork]
    end

    private

    def found
      puts "#{@raw[:full_name]} already cloned"
    end

    def clone
      Rugged::Repository.clone_at(@raw[:ssh_url], @path)
    end

    def config(repo)
      @params[:git_config].each { |key, value| repo.config[key] = value }
    end

    def add_upstream
      upstream = @client.repo(@raw[:id]).source.git_url
      Dir.chdir(@path) { system "git remote add upstream '#{upstream}'" }
    end
  end
end
