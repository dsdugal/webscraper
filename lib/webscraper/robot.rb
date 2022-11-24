# frozen_string_literal: true

# This project will be released as a gem in the future; update the reference accordingly.
require_relative ".././../webcrawler/lib/webcrawler"

require "mongo"
require_relative "data"
require_relative "log"
require_relative "options"

module WebScraper

  # The worker class that manages the ETL workflow.
  #
  class Robot

    # Database properties.
    #
    DATABASE_COLLECTION = "pages"
    DATABASE_HOST = "localhost"
    DATABASE_NAME = "webscraper"
    DATABASE_PORT = 27017
    DATABASE_PROTOCOL = "mongodb"

    DATABASE_ADDRESS = "#{DATABASE_PROTOCOL}://#{DATABASE_HOST}:#{DATABASE_PORT}"

    attr_reader :log

    # @param [Array] arguments - command line arguments
    #
    def initialize(arguments)
      @options = Options.new(arguments)
      @log = Log.new(@options.debug)

      (log.fatal("no target specified"); stop) if @options.target.nil?

      @client = Mongo::Client.new(DATABASE_ADDRESS)
      @crawler = WebCrawler::Crawler.new(@options.username, @options.password)
      @data = Data.new
      @database = Mongo::Database.new(@client, DATABASE_NAME)
    end

    # Execution workflow.
    #
    def run
      # Pre-processing.
      @data.build!

      # Processing.
      extract
      transform
      upload

      # Post-processing.
      @data.clean!
      client.close
    end

    # Clean up processing artifacts and finish execution.
    #
    def stop
      @database&.drop
      @client&.close
      @data&.clean!

      exit
    end

    private

    # Download a copy of a web page from the internet.
    #
    def extract
      log.debug(__method__)

      begin
        content = @crawler.get(@options.target, auth: @options.username)
      rescue WebCrawler::Error => Error
        log.fatal(error.message)

        stop
      end

      path = WebScraper::url_to_path(@data.raw, @options.target)
    
      File.write(path, content)

      log.info("saved web page as #{File.basename(path)}")
    end

    # Map the URL of a web page to the hash of its content.
    #
    def transform
      log.debug(__method__)

      url_hash = @data.raw.entries.find { |entry| !entry.directory? }.to_s
      content_hash = WebScraper::str_to_hash(File.read(@data.raw + file_name))

      WebScraper::dump_cache(@data.queue, { url: url_hash, content: content_hash })

      log.info("mapped #{file_path}")
    end

    # Transfer the data from the queue to the database.
    #
    def upload
      log.debug(__method__)

      queued = WebScraper::load_cache(@data.queue)

      # Attempt to find an existing entry for the target URL in the database.
      filter = { url: queued["url"] }
      found = @database.collection(DATABASE_COLLECTION).find(filter)
      stored = found.entries&.first&.tap { |entry| entry.delete("_id") }

      if queued == stored
        log.info("found mapped entry in #{DATABASE_NAME}.#{DATABASE_COLLECTION}")
      elsif found.any?
        @database.collection(DATABASE_COLLECTION).find_one_and_replace(filter, queued)

        log.info("replaced mapped entry in #{DATABASE_NAME}.#{DATABASE_COLLECTION}")
      else
        @database.collection(DATABASE_COLLECTION).insert_one(queued)

        log.info("inserted mapped entry in #{DATABASE_NAME}.#{DATABASE_COLLECTION}")
      end
    end

  end

end
