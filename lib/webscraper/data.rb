# frozen_string_literal: true

module WebScraper

  # A helper class that manages the directories and files that are required for processing.
  #
  class Data

    attr_reader :queue, :raw

    def initialize
      root = Pathname.new("#{Dir.pwd}/data/")

      @raw = root + "data"
      @queue = root + "queue.json"
    end

    # Construct all directories and files necessary for processing.
    #
    def build!
      FileUtils.mkpath(raw) rescue Errno::EEXIST
      FileUtils.touch(queue)

      WebScraper::dump_cache(queue, {})
    end

    # Clean up processing artifacts.
    #
    def clean!
      Dir.glob("#{raw}/**/*").each { |file| FileUtils.rm_rf(file) }

      WebScraper::dump_cache(queue, {})
    end

  end

end
