module GeoPattern
  class Pattern
    private

    attr_reader :svg

    public

    attr_accessor :background, :structure

    def initialize(svg = SvgImage.new)
      @svg = svg
    end


    # Generate things for the pattern
    #
    # @param [#generate) generator
    #   The generator which should do things with this pattern - e.g. adding
    #   background or a structure
    def generate_me(generator)
      generator.generate self
    end

    # Convert pattern to svg
    def to_svg
      image.to_s
    end
    alias_method :to_s, :to_svg

    # @see #to_svg
    # @deprecated
    def svg_string
      $stderr.puts 'Using "#svg_string" is deprecated as of 1.3.1. Please use "#to_svg" instead.'

      to_svg
    end

    # @see #to_base64
    # @deprecated
    def base64_string
      $stderr.puts 'Using "#base64_string" is deprecated as of 1.3.1. Please use "#to_base64" instead.'

      to_base64
    end

    # Convert to base64
    def to_base64
      Base64.strict_encode64(to_svg)
    end

    # Convert to data uri
    def to_data_uri
      "url(data:image/svg+xml;base64,#{base64_string});"
    end

    # @see #to_data_uri
    # @deprecated
    def uri_image
      $stderr.puts 'Using "#uri_image" is deprecated as of 1.3.1. Please use "#to_data_uri" instead.'

      to_data_uri
    end

    private

    def image
      svg << background if background
      svg << structure if structure

      svg
    end
  end
end
