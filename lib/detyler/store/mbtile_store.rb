module Detyler
	class MbtileStore < TileStore
		def initialize(db_file_name)
	    @store = Mbtiles.new(db_file_name)
		end

		def has_tile?(z, x, y)
			@store.has_tile?(z, x, y)
		end

		def tile(z, x, y)
			@store.tile(z, x, y)
		end

		def save(z, x, y, data)
			@store.save(z, x, y, data)
		end

		def delete(z, x, y)
			@store.delete(z, x, y)
		end

		def location
			File.absolute_path(db_file_name)
		end
	end
end