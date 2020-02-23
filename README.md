# Detyler

Detyler is a gem for downloading tile sets. Currently the only supported set is [LINZ](http://www.linz.govt.nz/). 
It has support for using a cache, meaning it will only download tiles it does not have. 
Can output tiles either to a directory or as an [mbtiles](https://github.com/mapbox/mbtiles-spec/blob/master/1.1/spec.md) database. 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'detyler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install detyler

## Usage

Please be aware of usage limits that tile sources may impose and stay within them.

A source is anything that responds to a `tile(z, x, y)` message and returns the image data

```ruby
require 'detyler'

detyler = Detyler::Job.new
linz_topo50_layer_id = "767"
detyler.source = Detyler::LINZSource.new("<your_api_key>", linz_topo50_layer_id)
detyler.store = Detyler::FileSystemStore.new(File.join("/Users/me/tile_cache/linz-tiles/", linz_topo50_layer_id))

w, s, e, n = 174.7474955, -41.3106508, 174.8015473, -41.2814872 # central Wellington, New Zealand

detyler.run([w, s, e, n], [12, 15])
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## TODO

- Clean up code: proper logging, etc
- Make creating the tile composites optional.
- Use oilypng rather than chunkypng
- Allow transforms of tiles as they are processed - provide a hook that lets you perform an operation on the tile data once it has been retrieved from the source and before it is saved.
- Move mbtiles into a separate gem
- Move tile/coordinate helpers into a separate gem?
- Generalise the web tile source
- Add option for multithreaded download of tiles
- LINZSource back off when 429 is hit
- Set User Agent when downloading


## Resources

- https://boundingbox.klokantech.com/
- http://www.netzwolf.info/kartografie/osm/tilebrowser?lat=45&lon=-90&zoom=5
- http://tools.geofabrik.de/map/#0/47.9268/-2.1407&type=Geofabrik_Standard&grid=1&mlat=5.34718&mlon=31.25778
- http://www.maptiler.org/google-maps-coordinates-tile-bounds-projection/


## Contributing

1. Fork it ( https://github.com/ajesler/detyler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
