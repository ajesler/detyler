require 'sqlite3'

module Detyler
  class Mbtiles
    attr_reader :tile_format, :db_file_name

    def initialize(db_file_name, format=:png)
      @db_file_name = db_file_name
      load_database(db_file_name)

      @tile_format = read_tile_format
    end

    def has_tile?(z, x, y)
      @db.get_first_value(SQL_MATCHING_TILE_COUNT, z, x, y) != 0
    end

    def tile(z, x, y)
      @db.get_first_value(SQL_READ_TILE, z, x, y)
    end

    def save(z, x, y, data)
      @db.execute(SQL_INSERT_TILE, z, x, y, data)
    end

    def delete(z, x, y)
      @db.execute(SQL_DELETE_TILE, z, x, y)
    end

    def metadata
      rows = @db.execute(SQL_READ_METADATA)
      rows.each.with_object({}) { |row, hash| hash[row[0]] = row[1] }
    end

    # TODO zoomlevels, bounding_box(zoom)

    def close
      @db.close
    end

    private

    def load_database(db_file_name)
      db_exists = File.exists?(db_file_name)
      @db = SQLite3::Database.new(db_file_name)

      if !db_exists
        @db.execute(SQL_CREATE_TILES_TABLE)
        @db.execute(SQL_CREATE_METADATA_TABLE)

        @db.execute(SQL_INSERT_METADATA, "format", @tile_format.to_s)
      end
    end

    def read_tile_format
      @db.get_first_value(SQL_READ_TILE_FORMAT)
    end

    SQL_CREATE_TILES_TABLE = "CREATE TABLE IF NOT EXISTS tiles (zoom_level integer, tile_column integer, tile_row integer, tile_data blob)"
    SQL_INSERT_TILE = "INSERT INTO tiles (zoom_level, tile_column, tile_row, tile_data) VALUES(?, ?, ?, ?)"
    SQL_READ_TILE = "SELECT tile_data FROM tiles WHERE zoom_level=? and tile_column=? and tile_row=?"
    SQL_DELETE_TILE = "DELETE FROM tiles WHERE zoom_level=? and tile_column=? and tile_row=?"
    SQL_CREATE_METADATA_TABLE = "CREATE TABLE IF NOT EXISTS metadata (name text, value text)"
    SQL_INSERT_METADATA = "INSERT INTO metadata (name, value) VALUES (?, ?)"
    SQL_READ_METADATA = "SELECT name, value FROM metadata"
    SQL_READ_TILE_FORMAT = "SELECT value FROM metadata where name = 'format'"
    SQL_MATCHING_TILE_COUNT = "SELECT COUNT(*) FROM tiles WHERE zoom_level=? and tile_column=? and tile_row=?"
  end
end