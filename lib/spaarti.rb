##
# This module manages local git repos
module Spaarti
  class << self
    ##
    # Insert a helper .new() method for creating a new Site object

    def new(*args)
      self::Site.new(*args)
    end
  end
end

require 'spaarti/version'
require 'spaarti/config'
require 'spaarti/repo'
require 'spaarti/site'
