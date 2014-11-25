module GeoPattern
  class MosaicSquaresPattern < BasePattern
    def render_to_svg
      triangle_size = map(hex_val(0, 1), 0, 15, 15, 50)

      svg.set_width(triangle_size * 8)
      svg.set_height(triangle_size * 8)

      i = 0
      for y in 0..3
        for x in 0..3
          if x.even?
            if y.even?
              draw_outer_mosaic_tile(x*triangle_size*2, y*triangle_size*2, triangle_size, hex_val(i, 1))
            else
              draw_inner_mosaic_tile(x*triangle_size*2, y*triangle_size*2, triangle_size, [hex_val(i, 1), hex_val(i+1, 1)])
            end
          else
            if y.even?
              draw_inner_mosaic_tile(x*triangle_size*2, y*triangle_size*2, triangle_size, [hex_val(i, 1), hex_val(i+1, 1)])
            else
              draw_outer_mosaic_tile(x*triangle_size*2, y*triangle_size*2, triangle_size, hex_val(i, 1))
            end
          end
          i += 1
        end
      end
    end

    def draw_inner_mosaic_tile(x, y, triangle_size, vals)
      triangle = build_right_triangle_shape(triangle_size)
      opacity  = opacity(vals[0])
      fill     = fill_color(vals[0])
      styles   = {
        "stroke"         => STROKE_COLOR,
        "stroke-opacity" => STROKE_OPACITY,
        "fill-opacity"   => opacity,
        "fill"           => fill
      }
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size}, #{y}) scale(-1, 1)"}))
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size}, #{y+triangle_size*2}) scale(1, -1)"}))

      opacity = opacity(vals[1])
      fill    = fill_color(vals[1])
      styles  = {
        "stroke"         => STROKE_COLOR,
        "stroke-opacity" => STROKE_OPACITY,
        "fill-opacity"   => opacity,
        "fill"           => fill
      }
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size}, #{y+triangle_size*2}) scale(-1, -1)"}))
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size}, #{y}) scale(1, 1)"}))
    end

    def draw_outer_mosaic_tile(x, y, triangle_size, val)
      opacity  = opacity(val)
      fill     = fill_color(val)
      triangle = build_right_triangle_shape(triangle_size)
      styles   = {
        "stroke"         => STROKE_COLOR,
        "stroke-opacity" => STROKE_OPACITY,
        "fill-opacity"   => opacity,
        "fill"           => fill
      }

      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x}, #{y+triangle_size}) scale(1, -1)"}))
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size*2}, #{y+triangle_size}) scale(-1, -1)"}))
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x}, #{y+triangle_size}) scale(1, 1)"}))
      svg.polyline(triangle, styles.merge({"transform" => "translate(#{x+triangle_size*2}, #{y+triangle_size}) scale(-1, 1)"}))
    end

    def build_right_triangle_shape(side_length)
      "0, 0, #{side_length}, #{side_length}, 0, #{side_length}, 0, 0"
    end
  end
end
