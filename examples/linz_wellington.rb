require 'detyler'

detyler = Detyler::Job.new
linz_topo50_layer_id = "767"
detyler.source = Detyler::LINZSource.new("<your_api_key>", linz_topo50_layer_id)
detyler.store = Detyler::FileSystemStore.new(File.join("/tmp/tile_cache/linz-tiles/", linz_topo50_layer_id))

w, s, e, n = 174.7474955, -41.3106508, 174.8015473, -41.2814872 # central Wellington, New Zealand

detyler.run([w, s, e, n], [12, 15])