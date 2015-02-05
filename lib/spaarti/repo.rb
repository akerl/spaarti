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
      clone
      Dir.chdir(@path) { config && add_upstream }
    end

    private

    def found
      puts "#{@raw[:full_name]} already cloned"
    end

    def clone
      system "git clone '#{@raw[:ssh_url]}' '#{@path}'"
    end

    def config
      @params[:git_config].each { |k, v| system "git config '#{k}' '#{v}'" }
    end

    def add_upstream
      return unless @raw[:fork]
      upstream = @client.repo(@raw[:id]).source.git_url
      system "git remote add upstream '#{upstream}'"
    end
  end
end
