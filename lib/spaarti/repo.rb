module Spaarti
  ##
  # Repo object, handles individual repo syncing and state
  class Repo
    def initialize(data)
      @raw = data
    end

    def sync!(params)
      path = params[:format] % @raw
      return found if Dir.exist?(path)
      clone(path) && config(path, params[:git_config])
    end

    private

    def found
      puts "#{@raw[:full_name]} already cloned"
    end

    def clone(path)
      system "git clone '#{@raw[:ssh_url]}' '#{path}'"
    end

    def config(path, git_config)
      Dir.chdir(path) do
        git_config.each { |k, v| system "git config '#{k}' '#{v}'" }
      end
    end
  end
end
