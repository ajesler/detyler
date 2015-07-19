require 'detyler/version'
require 'detyler/tile_list'
require 'detyler/mbtiles'
require 'detyler/tile_bounds'
require 'detyler/composite_from_tiles'
require 'detyler/source/linz_source'
require 'detyler/store/tile_store'
require 'detyler/store/file_system_store'
require 'detyler/store/mbtile_store'

module Detyler
	class Job
		attr_accessor :source, :store

		def initialize
			@store = nil
			@source = nil
		end

		def run(bounding_box, zoom)
			raise Error, "store and source must both be set" if @store.nil? || @source.nil?

			tiles = TileList.from_bounding_box(*bounding_box, zoom)

			puts "Saving tiles to #{@store.location}"

			tile_bounds = TileBounds.new

			tiles.each do |z, x, y|
				has_tile = @store.has_tile?(z, x, y)
				puts "Processing #{z}: #{x}, #{y} - download=#{!has_tile}"

				tile_bounds.update(z, x, y)

				if !has_tile
					tile_data = @source.tile(z, x, y)

					if tile_data.nil?
						puts "\tNo data returned"
					end

					@store.save(z, x, y, tile_data)
				end
			end

			tile_bounds.zooms.each do |zoom|
				# create tile image
				composite = CompositeFromTiles.new(@store, *tile_bounds[zoom], zoom)
				composite.create
			end
		end
	end
end