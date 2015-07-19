module Detyler
	class TileStore
		def has_tile?(z, x, y)
			raise NotImplementedError, "Please implement this method in your tile store"
		end

		def tile(z, x, y)
			raise NotImplementedError, "Please implement this method in your tile store"
		end

		def save(z, x, y, data)
			raise NotImplementedError, "Please implement this method in your tile store"
		end

		def delete(z, x, y)
			raise NotImplementedError, "Please implement this method in your tile store"
		end

		def location
			raise NotImplementedError, "Please implement this method in your tile store"
		end
	end
end