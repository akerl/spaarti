require 'pathname'

module Spaarti
  ##
  # Repo object, handles individual repo syncing and state
  class Repo
    def initialize(data, client, params = {})
      @data = data
      @client = client
      @options = params
      @path = resolve_path(@options[:formats], @data) % @data
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

    def resolve_path(formats, data)
      formats.each do |format|
        return format[:path] if format[:match].nil?
        next unless data[:full_name].include? format[:match]
        return format[:path]
      end
      raise 'No valid path format found'
    end

    def log(msg)
      puts msg unless @options[:quiet]
    end

    def err(msg)
      warn msg
    end

    def run(cmd, error_msg)
      res = system "#{cmd} 1>/dev/null 2>/dev/null"
      err(error_msg) unless res
    end

    def url
      @url ||= @data["#{@options[:url_type]}_url".to_sym]
    end

    def clone
      return log("#{@data[:full_name]} already cloned") if Dir.exist? @path
      log "Cloning #{url} to #{@path}"
      run(
        "git clone '#{url}' '#{@path}'",
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
      ['foreach git fetch --all --tags', 'update --init'].each do |cmd|
        run(
          "git submodule #{cmd}",
          "Failed to update submodules in #{@path}"
        )
      end
    end
  end
end
