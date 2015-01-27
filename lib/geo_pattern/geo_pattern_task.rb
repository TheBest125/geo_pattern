require 'geo_pattern'
require 'geo_pattern/rake_task'

module GeoPattern
  # GeoPatternTask
  #
  # @see Rakefile
  class GeoPatternTask < RakeTask
    # @!attribute [r] data
    #   The data which should be used to generate patterns
    attr_reader :data

    # @!attribute [r] allowed_patterns
    #   The the patterns which are allowed to be used
    attr_reader :allowed_patterns

    # Create a new geo pattern task
    #
    # @param [Hash] data
    #   The data which should be used to generate patterns
    #
    # @param [Array] allowed_patterns
    #   The allowed_patterns
    #
    # @see RakeTask
    #   For other arguments accepted
    def initialize(opts = {})
      super

      fail ArgumentError, :data if @options[:data].nil?

      @data             = @options[:data]
      @allowed_patterns = @options[:allowed_patterns]
    end

    # @private
    def run_task(_verbose)
      patterns.each do |path, string|
        pattern = GeoPattern.generate(string, patterns: allowed_patterns)
        File.write(File.expand_path(path), pattern.to_svg)
      end
    end
  end
end
