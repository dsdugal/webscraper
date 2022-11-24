# frozen_string_literal: true

require "digest"

# Methods that may be used throughout the WebScraper project, defined here for consistency.
#
module WebScraper

  # Write data to a cache file.
  #
  # @param [Pathname] path - the path to a cache file
  # @param [Hash] data - the data to be written to a cache file
  #
  def self.dump_cache(path, data)
    File.write(path, JSON.pretty_generate(data, { indent: "  ", object_nl: "\n", array_nl: "\n" }))
  end

  # Read the contents of a cache file.
  #
  # @param [Pathname] path - the path to a cache file
  # @return [Hash]
  #
  def self.load_cache(path)
    JSON.parse(File.read(path))
  rescue Errno::ENOENT => error
    {}
  end

  # Convert a string to its SHA-256 hash representation.
  #
  # @param [String] str - the string to convert
  # @return [String]
  #
  def self.str_to_hash(str)
    Digest::SHA256.hexdigest(str)
  end

  # Convert a URL to the local file path that the web page data will be stored at.
  #
  # @param [Pathname] directory - the local directory where the web page data will be stored
  # @param [Addressable::URI] url - the location of a valid web page on the internet
  # @return [Pathname]
  #
  def self.url_to_path(directory, url)
    directory + str_to_hash(url)
  end

end
