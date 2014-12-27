require 'base64'
require 'digest/sha1'
require 'color'

module GeoPattern
  class PatternGenerator
    DEFAULTS = {
      :base_color => '#933c3c'
    }

    PATTERNS = {
      'chevrons' => ChevronPattern,
      'concentric_circles' => ConcentricCirclesPattern,
      'diamonds' => DiamondPattern,
      'hexagons' => HexagonPattern,
      'mosaic_squares' => MosaicSquaresPattern,
      'nested_squares' => NestedSquaresPattern,
      'octagons' => OctagonPattern,
      'overlapping_circles' => OverlappingCirclesPattern,
      'overlapping_rings' => OverlappingRingsPattern,
      'plaid' => PlaidPattern,
      'plus_signs' => PlusSignPattern,
      'sine_waves' => SineWavePattern,
      'squares' => SquarePattern,
      'tessellation' => TessellationPattern,
      'triangles' => TrianglePattern,
      'xes' => XesPattern,
    }.freeze

    FILL_COLOR_DARK  = "#222"
    FILL_COLOR_LIGHT = "#ddd"
    STROKE_COLOR     = "#000"
    STROKE_OPACITY   = 0.02
    OPACITY_MIN      = 0.02
    OPACITY_MAX      = 0.15

    attr_reader :opts, :hash, :svg

    def initialize(string, opts={})
      @opts = DEFAULTS.merge(opts)
      @hash = Digest::SHA1.hexdigest string
      @svg  = SVG.new

      generate_background
      generate_pattern
    end

    def svg_string
      svg.to_s
    end
    alias_method :to_s, :svg_string

    def base64_string
      Base64.strict_encode64(svg_string)
    end

    def uri_image
      "url(data:image/svg+xml;base64,#{base64_string});"
    end

    def generate_background
      if opts[:color]
        rgb = Color::RGB.from_html(opts[:color])
      else
        hue_offset     = PatternHelpers.map(PatternHelpers.hex_val(hash, 14, 3), 0, 4095, 0, 359)
        sat_offset     = PatternHelpers.hex_val(hash, 17, 1)
        base_color     = Color::RGB.from_html(opts[:base_color]).to_hsl
        base_color.hue = base_color.hue - hue_offset;

        if (sat_offset % 2 == 0)
          base_color.saturation = base_color.saturation + sat_offset
        else
          base_color.saturation = base_color.saturation - sat_offset
        end
        rgb = base_color.to_rgb
      end
      r = (rgb.r * 255).round
      g = (rgb.g * 255).round
      b = (rgb.b * 255).round
      svg.rect(0, 0, "100%", "100%", {"fill" => "rgb(#{r}, #{g}, #{b})"})
    end

    def generate_pattern
      if opts[:generator].is_a? String
        generator = PATTERNS[opts[:generator]]
        puts SVG.as_comment("String pattern references are deprecated as of 1.3.0")
      elsif opts[:generator] < BasePattern
        if PATTERNS.values.include? opts[:generator]
          generator = opts[:generator]
        else
          abort("Error: the requested generator is invalid")
          generator = nil
        end
      end

      if generator.nil?
        generator = PATTERNS.values[[PatternHelpers.hex_val(hash, 20, 1), PATTERNS.length - 1].min]
      end

      # Instantiate the generator with the needed references
      # and render the pattern to the svg object
      generator.new(svg, hash).render_to_svg
    end
  end
end
