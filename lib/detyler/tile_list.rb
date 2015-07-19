require 'pry'

module Detyler
  class TileList
    # https://github.com/makinacorpus/landez/blob/1d45063d7293dafac4e9fdc5b208999e35544204/landez/proj.py

    # z can be a range, an array, or a single zoom level
    def self.from_bounding_box(w, s, e, n, z)
      validate_bounds(w, s, e, n)

      tile_list = Enumerator.new do |yielder|
        zoom_levels(z).each do |z|
          x_max, y_min = tile_number(n, e, z)
          x_min, y_max = tile_number(s, w, z)

          x_min.upto(x_max).each do |x|
            y_min.upto(y_max) do |y|
              yielder.yield z, x, y
            end
          end
        end
      end
    end

    # from https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Tile_servers
    def self.tile_number(lat_deg, lng_deg, zoom)n = 2.0 ** zoom
      lat_rad = (lat_deg) * (Math::PI/180)
      y = ((1.0 - Math.log( Math.tan(lat_rad) + (1 / Math.cos(lat_rad))) / Math::PI) / 2.0 * n).floor

      x = ((lng_deg + 180.0) / 360.0 * n).floor

      return [x, y]
    end

    private

    def self.zoom_levels(source)
      case(source)
        when Array then return source
        when Range then return source.to_a
        when Fixnum then return [source]
      end
    end

    def self.validate_bounds(w, s, e, n)
      lat_max = [n.abs, s.abs].max
      lng_max = [e.abs, w.abs].max
       if lat_max > 90 || lng_max > 180
        raise ArgumentError, "Coordinates outside bounds of [-90, 90] or [-180,+180]"
      end
    end
  end
end