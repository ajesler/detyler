require 'httparty'

module Detyler
	class LINZSource
		SUBDOMAINS = ('a'..'d').to_a

		def initialize(api_key, layer_id)
			@api_key = api_key
			@layer_id = layer_id
		end

		def tile(z, x, y)
			download_tile(z, x, y).body
		end

		private 

		def download_tile(z, x, y)
			HTTParty.get(build_url(z, x, y))
		end

		def build_url(z, x, y)
			s = SUBDOMAINS.sample
			"http://tiles-#{s}.data-cdn.linz.govt.nz/services;key=#{@api_key}/tiles/v4/layer=#{@layer_id}/EPSG:3857/#{z}/#{x}/#{y}.png"
		end
	end
end