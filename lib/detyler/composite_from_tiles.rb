require 'chunky_png'

module Detyler
	class CompositeFromTiles
		TILE_SIZE = 256

		def initialize(store, min_x, max_x, min_y, max_y, zoom)
			@store = store
			@min_x = min_x
			@max_x = max_x
			@min_y = min_y
			@max_y = max_y
			@zoom = zoom
		end

		def create
			width_in_tiles = (@max_x+1 - @min_x)
			height_in_tiles = (@max_y+1 - @min_y)
			width = TILE_SIZE * width_in_tiles
			height = TILE_SIZE * height_in_tiles

			puts "Creating tile composite: z=#{@zoom}, x:#{@min_x}->#{@max_x}, y:#{@min_y}->#{@max_y}, width=#{width}, height=#{height}"

			canvas = ChunkyPNG::Canvas.new(width, height)

			@min_x.upto(@max_x).each.with_index do |x, xi|
        @min_y.upto(@max_y).each.with_index do |y, yi|
					tile = ChunkyPNG::Image.from_file(File.join(@store.location, "#{@zoom}/#{x}/#{y}.png"))
					tile.grayscale!

					canvas.replace!(tile, TILE_SIZE * xi, TILE_SIZE * yi)
        end
      end

      output_file = File.join(@store.location, "#{@zoom}_#{@min_x}_#{@max_x}_#{@min_y}_#{@max_y}.png")
      canvas.to_image.save(output_file)
      puts "Saved composite to #{output_file}"
		end
	end
end