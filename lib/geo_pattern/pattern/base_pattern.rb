module GeoPattern
  class BasePattern
    attr_reader :svg, :hash, :fill_color_dark, :fill_color_light, :stroke_color, :stroke_opacity, :opacity_min, :opacity_max

    def initialize(svg, hash, options = {})
      @svg  = svg
      @hash = hash

      @fill_color_dark  = options.fetch(:fill_color_dark, '#222')
      @fill_color_light = options.fetch(:fill_color_light,'#ddd')
      @stroke_color     = options.fetch(:stroke_color,    '#000')
      @stroke_opacity   = options.fetch(:stroke_opacity,  0.02)
      @opacity_min      = options.fetch(:opacity_min,     0.02)
      @opacity_max      = options.fetch(:opacity_max,     0.15)
    end

    # Public: mutate the given `svg` object with a rendered pattern
    #
    # Note: this method _must_ be implemented by sub-
    # classes.
    #
    # svg - the SVG container
    #
    # Returns a reference to the same `svg` object
    # only this time with more patterns.
    def render_to_svg
      raise NotImplementedError
    end

    def hex_val(index, len)
      PatternHelpers.hex_val(hash, index, len)
    end

    def fill_color(val)
      (val.even?) ? fill_color_light : fill_color_dark
    end

    def opacity(val)
      map(val, 0, 15, opacity_min, opacity_max)
    end

    def map(value, v_min, v_max, d_min, d_max)
      PatternHelpers.map(value, v_min, v_max, d_min, d_max)
    end

    protected
    def build_plus_shape(square_size)
      [
        "rect(#{square_size},0,#{square_size},#{square_size * 3})",
        "rect(0, #{square_size},#{square_size * 3},#{square_size})"
      ]
    end
  end
end
