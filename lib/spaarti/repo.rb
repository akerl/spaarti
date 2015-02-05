require 'pathname'

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
      return log("#{@raw[:full_name]} already cloned") if Dir.exist?(@path)
      clone
      Dir.chdir(@path) { config && add_upstream }
    end

    def parent_of(repo)
      repo.relative_path_from(Pathname.new(@path)).each_filename.first != '..'
    end

    private

    def log(msg)
      puts msg unless @params[:quiet]
    end

    def err(msg)
      STDERR.puts msg
    end

    def run(cmd, error_msg)
      res = system "#{cmd} &>/dev/null"
      err(error_msg) unless res
    end

    def clone
      log "Cloning #{@raw[:ssh_url]} to #{@path}"
      run(
        "git clone '#{@raw[:ssh_url]}' '#{@path}' &>/dev/null",
        "Failed to clone #{@raw[:ssh_url]}"
      )
    end

    def config
      @params[:git_config].each do |k, v|
        run("git config '#{k}' '#{v}'", "Failed to set config for #{@path}")
      end
    end

    def add_upstream
      return unless @raw[:fork]
      upstream = @client.repo(@raw[:id]).source.git_url
      run(
        "git remote add upstream '#{upstream}'",
        "Failed to add upstrema for #{@path}"
      )
    end
  end
end
