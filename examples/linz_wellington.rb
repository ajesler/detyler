require 'detyler'

detyler = Detyler::Job.new
linz_topo50_layer_id = "767"
arial_photos_set_id = "2"
# detyler.source = Detyler::LINZSource.new("2b0176d4531646788a72735272f50a15", layer_id: linz_topo50_layer_id)
detyler.source = Detyler::LINZSource.new("2b0176d4531646788a72735272f50a15", set_id: arial_photos_set_id)
detyler.store = Detyler::FileSystemStore.new(File.join("/Users/ajesler/tile_cache/linz-tiles/", arial_photos_set_id))

w, s, e, n = 174.7474955, -41.3106508, 174.8015473, -41.2814872 # central Wellington, New Zealand

detyler.run([w, s, e, n], [10, 12, 15, 16, 17])