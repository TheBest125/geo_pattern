module GeoPattern
  class PlusSignPattern < BasePattern
    def render_to_svg
      square_size = map(hex_val(0, 1), 0, 15, 10, 25)
      plus_size   = square_size * 3
      plus_shape  = build_plus_shape(square_size)

      svg.set_width(square_size * 12)
      svg.set_height(square_size * 12)

      i = 0
      for y in 0..5
        for x in 0..5
          val     = hex_val(i, 1)
          opacity = opacity(val)
          fill    = fill_color(val)
          dx      = (y % 2 == 0) ? 0 : 1

          styles = {
            "fill"           => fill,
            "stroke"         => STROKE_COLOR,
            "stroke-opacity" => STROKE_OPACITY,
            "style"          => {
              "fill-opacity" => opacity
            }
          }

          svg.group(plus_shape, styles.merge({
            "transform" => "translate(#{x*plus_size - x*square_size + dx*square_size - square_size},#{y*plus_size - y*square_size - plus_size/2})"}))

          # Add an extra column on the right for tiling.
          if (x == 0)
            svg.group(plus_shape, styles.merge({
              "transform" => "translate(#{4*plus_size - x*square_size + dx*square_size - square_size},#{y*plus_size - y*square_size - plus_size/2})"}))
          end

          # Add an extra row on the bottom that matches the first row, for tiling.
          if (y == 0)
            svg.group(plus_shape, styles.merge({
              "transform" => "translate(#{x*plus_size - x*square_size + dx*square_size - square_size},#{4*plus_size - y*square_size - plus_size/2})"}))
          end

          # Add an extra one at top-right and bottom-right, for tiling.
          if (x == 0 && y == 0)
            svg.group(plus_shape, styles.merge({
              "transform" => "translate(#{4*plus_size - x*square_size + dx*square_size - square_size},#{4*plus_size - y*square_size - plus_size/2})"}))
          end
          i += 1
        end
      end
    end
  end
end
