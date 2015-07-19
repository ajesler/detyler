require 'spec_helper'

RSpec.describe Detyler::TileList do
	def collect_tiles(enumerator)
		enumerator.each.with_object([]) { |xyz, array| array << xyz }
	end

	def expect_tile_number(lat, lng, zoom, expected_x, expected_y)
		expect(Detyler::TileList.tile_number(lat, lng, zoom)).to eq [expected_x, expected_y]
	end

	def expect_bounding_box_tiles(w, s, e, n, z, expected_tiles)
		tile_enumerator = Detyler::TileList.from_bounding_box(w, s, e, n, z)
		tiles = collect_tiles(tile_enumerator)
		expect(tiles).to eq expected_tiles
	end

	describe '.tile_number' do
		it "should calulate x and y from lat and lng" do
			expect_tile_number(45, -85, 0, 0, 0)
			expect_tile_number(45, -85, 14, 4323, 5893)
			expect_tile_number(45, -85, 5, 8, 11)
			expect_tile_number(40.1222, 20.6852, 9, 285, 193)
			expect_tile_number(40.1222, 20.6852, 9, 285, 193)
			expect_tile_number(38.91326516559442, -77.03239381313323, 10, 292, 391)
			expect_tile_number(-13.40516, 48.27484, 18, 166224, 140923)
			expect_tile_number(85, -180, 0, 0, 0)
			expect_tile_number(-85, 179.9, 3, 7, 7)
		end
	end

	describe ".from_bounding_box" do
		let(:expected_output_zoom_0) { [[0, 0, 0]] }
		let(:expected_output_zoom_0_1) { [[0, 0, 0], [1, 0, 0], [1, 0, 1], [1, 1, 1], [1, 1, 0]] }

		context "when zoom is a Fixnum" do
			it "should match the expected output" do
				expect_bounding_box_tiles(-180.0, 1, -1, 85.0, 1, [[1, 0, 0]])

				expected_result = [[14, 3413, 6202], [14, 3413, 6203]]
				expect_bounding_box_tiles(-105, 39.99, -104.99, 40, 14, expected_result)

				expected_result = [[10, 515, 373], [10, 515, 374], [10, 516, 373], [10, 516, 374]]
				expect_bounding_box_tiles(1.3, 43.5, 1.6, 43.7, 10, expected_result)
			end
		end

		context "when zoom is an array" do
			it "should match the expected output" do
				expected_result = [[14, 3413, 6202], [14, 3413, 6203], [15, 6826, 12405], [15, 6826, 12406], [15, 6827, 12405], [15, 6827, 12406]]
				expect_bounding_box_tiles(-105, 39.99, -104.99, 40, [14, 15], expected_result)
			end
		end

		context "when zoom is a range" do
			it "should match the expected output" do
				expected_result = [[14, 3413, 6202], [14, 3413, 6203], [15, 6826, 12405], [15, 6826, 12406], [15, 6827, 12405], [15, 6827, 12406]]
				expect_bounding_box_tiles(-105, 39.99, -104.99, 40, 14..15, expected_result)
			end
		end

		context "when a bound is exceeded" do
			it "should raise an error" do 
				expect { Detyler::TileList.from_bounding_box(-180.0, -91.0, 180.0, 90.0, 0, [10]) }.to raise_error(ArgumentError)
			end
		end
	end
end