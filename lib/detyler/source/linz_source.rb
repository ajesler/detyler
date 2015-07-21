require 'httparty'
require "pry"

module Detyler
	class LINZSource
		SUBDOMAINS = ('a'..'d').to_a

		def initialize(api_key, options={})
			@api_key = api_key

			if options[:layer_id].nil? && options[:set_id].nil?
				raise ArgumentError, "You must supply either a layer_id or a set_id"
			end

			@layer_id = options[:layer_id]
			@set_id = options[:set_id]
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
			type_source = @set_id.nil? ? "layer=#{@layer_id}" : "set=#{@set_id}"

			"http://tiles-#{s}.data-cdn.linz.govt.nz/services;key=#{@api_key}/tiles/v4/#{type_source}/EPSG:3857/#{z}/#{x}/#{y}.png"
		end
	end
end