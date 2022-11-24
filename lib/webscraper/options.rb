# frozen_string_literal: true

require "addressable/uri"
require "optparse"
require "pathname"

module WebScraper

  # A helper class that manages the runtime options for the script. Default options are set by the constructor, and are
  # overwritten when valid alternatives are specified as command line arguments.
  #
  class Options

    attr_reader :debug, :password, :target, :username

    # @param [Arra] arguments - command line arguments
    #
    def initialize(arguments)
      # Required arguments.
      @target = nil

      # Optional arguments.
      @debug = false
      @username = nil
      @password = nil

      parse(arguments)
    end

    private

    # Generate the help menu banner.
    #
    # @return [String]
    #
    def help_banner
      "Welcome to WebScraper! Specify a target URL and WebScraper will save the SHA-256 hash of its contents in a " \
      "MongoDB database.\n\n" \
      "Usage: ruby bin/webscraper.rb <url> [options]\n\n" \
      "Options:"
    end

    # Parse command line arguments and set runtime behaviours as necessary.
    #
    # @param [Array] arguments - command line arguments
    #
    def parse(arguments)
      # The first argument is always the target url if the program passes the options parsing stage.
      @target = Addressable::URI.parse(arguments.shift) unless arguments.first.match?(/^-/)

      OptionParser.new do |options|
        options.banner = help_banner

        options.on("-d", "--debug", "Enable debug mode. (verbose logging)") { @debug = true }
        options.on("-h", "--help", "Display the help menu.") { puts(options); exit }
        options.on("-p", "--password", "Specify login password.") { |password| @password = password }
        options.on("-u", "--username", "Specify login username.") { |username| @username = username }
      end.parse!(arguments)
    end

  end

end
