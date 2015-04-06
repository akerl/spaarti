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
      clone
      Dir.chdir(@path) do
        config
        add_upstream
        update_submodules
      end
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

    def url
      @url ||= @data["#{@options[:url_type]}_url".to_sym]
    end

    def clone
      return log("#{@data[:full_name]} already cloned") if Dir.exist? @path
      log "Cloning #{url} to #{@path}"
      run(
        "git clone '#{url}' '#{@path}' &>/dev/null",
        "Failed to clone #{url}"
      )
    end

    def config
      @options[:git_config].each do |k, v|
        run("git config '#{k}' '#{v}'", "Failed to set config for #{@path}")
      end
    end

    def add_upstream
      return unless @data[:fork]
      return if `git remote`.split.include? 'upstream'
      upstream = @client.repo(@data[:id]).source.git_url
      run(
        "git remote add upstream '#{upstream}'",
        "Failed to add upstrema for #{@path}"
      )
    end

    def update_submodules
      run(
        'git submodule update --init',
        "Failed to update submodules in #{@path}"
      )
    end
  end
end
