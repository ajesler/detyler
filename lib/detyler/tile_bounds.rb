module Detyler
	class TileBounds
		def initialize
			@bounds = {}
		end

		def update(z, x, y)
			if @bounds.has_key?(z)
				bound = @bounds[z]
				bound[0] = x if x < bound[0]
				bound[1] = x if x > bound[1]
				bound[2] = y if y < bound[2]
				bound[3] = y if y > bound[3]

				@bounds[z] = bound
			else
				@bounds[z] = [x, x, y, y]
			end
		end

		def [](z)
			@bounds[z]
		end

		def zooms
			@bounds.keys
		end
	end
end