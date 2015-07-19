require 'fileutils'

module Detyler
	class FileSystemStore < TileStore
		def initialize(store_directory, format=:png)
			@store_directory = store_directory
			@format = format

			if !Dir.exists?(@store_directory)
				FileUtils.mkpath(@store_directory)
			end
		end

		def has_tile?(z, x, y)
			tile_exists?(z, x, y)
		end

		def tile(z, x, y)
			if tile_exists?(z, x, y)
				File.read(tile_file_name(z, x, y))
			else 
				nil
			end
		end

		def save(z, x, y, data)
			file_name = tile_file_name(z, x, y)
			FileUtils.mkpath(File.dirname(file_name))
			File.write(file_name, data)
		end

		def delete(z, x, y)
			if tile_exists?(z, x, u)
				File.delete(tile_file_name(z, x, y))
			end
		end

		def location
			File.absolute_path(@store_directory)
		end

		private

		def tile_file_name(z, x, y)
			File.join(@store_directory, "#{z}/#{x}/#{y}.#{@format}")
		end

		def tile_exists?(z, x, y)
			File.exists?(tile_file_name(z, x, y))
		end
	end
end