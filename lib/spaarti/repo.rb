require 'pathname'

module Spaarti
  ##
  # Repo object, handles individual repo syncing and state
  class Repo
    def initialize(data, client, params = {})
      @data = data
      @client = client
      @options = params
      @path = @options[:format] % @data
    end

    def sync!
      return log("#{@data[:full_name]} already cloned") if Dir.exist?(@path)
      clone
      Dir.chdir(@path) { config && add_upstream }
    end

    def parent_of(repo)
      repo.relative_path_from(Pathname.new(@path)).each_filename.first != '..'
    end

    private

    def log(msg)
      puts msg unless @options[:quiet]
    end

    def err(msg)
      STDERR.puts msg
    end

    def run(cmd, error_msg)
      res = system "#{cmd} &>/dev/null"
      err(error_msg) unless res
    end

    def clone
      log "Cloning #{@data[:ssh_url]} to #{@path}"
      run(
        "git clone '#{@data[:ssh_url]}' '#{@path}' &>/dev/null",
        "Failed to clone #{@data[:ssh_url]}"
      )
    end

    def config
      @options[:git_config].each do |k, v|
        run("git config '#{k}' '#{v}'", "Failed to set config for #{@path}")
      end
    end

    def add_upstream
      return unless @data[:fork]
      upstream = @client.repo(@data[:id]).source.git_url
      run(
        "git remote add upstream '#{upstream}'",
        "Failed to add upstrema for #{@path}"
      )
    end
  end
end
