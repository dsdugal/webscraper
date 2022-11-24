# frozen_string_literal: true

require "logger"

module WebScraper

  # A wrapper class for the basic Ruby logger class which sets up the default settings for the project log.
  #
  class Log < Logger

    # @param [TrueClass|FalseClass] debug - log messages at or above the 'debug' level
    #
    def initialize(debug = false)
      super(STDOUT)

      self.datetime_format = "%Y-%m-%d %H:%M:%S"
      self.formatter = proc { |severity, datetime, _, message| "[#{datetime}] #{severity.ljust(5)} -- #{message}\n" }
      self.level = debug ? Logger::DEBUG : Logger::INFO
    end

  end

end
