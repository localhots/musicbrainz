## MusicBrainz Web Service wrapper [![Travis CI](https://secure.travis-ci.org/magnolia-fan/musicbrainz.png)](http://travis-ci.org/magnolia-fan/musicbrainz)

### Ruby Version
**IMPORTANT!**

Ruby version 1.9+ required. No support for 1.8.7 anymore, update your application already!

### Installation
```
gem install musicbrainz
```
or add this line to your Gemfile
```ruby
gem "musicbrainz"
```

### Configuration
```ruby
MusicBrainz.configure do |c|
  # Application identity (required)
  c.app_name = "My Music App"
  c.app_version = "1.0"
  c.contact = "support@mymusicapp.com"

  # Cache config (optional)
  c.cache_path = "/tmp/musicbrainz-cache"
  c.perform_caching = true

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end
```

### Usage
```ruby
require "musicbrainz"

# Search for artists
@suggestions = MusicBrainz::Artist.search("Jet")

# Find artist by name or mbid
@foo_fighters = MusicBrainz::Artist.find_by_name("Foo Fighters")
@kasabian = MusicBrainz::Artist.find("69b39eab-6577-46a4-a9f5-817839092033")

# Use them like ActiveRecord models
@empire_tracks = @kasabian.release_groups[8].releases.first.tracks
```

### Api

MusicBrainz::Artist
```ruby
@artists = MusicBrainz::Artist.search(query)
@artist = MusicBrainz::Artist.find_by_name(name)
@artist = MusicBrainz::Artist.find(mbid)
@artist.id
@artist.type
@artist.name
@artist.country
@artist.date_begin
@artist.date_end
@artist.release_groups
```

MusicBrainz::ReleaseGroup
```ruby
@release_group = MusicBrainz::ReleaseGroup.find(mbid)
@release_group.id
@release_group.type
@release_group.title
@release_group.first_release_date
@release_group.releases
```

MusicBrainz::Release
```ruby
@release = MusicBrainz::Release.find(mbid)
@release.id
@release.title
@release.status
@release.date
@release.country
@release.tracks
```

MusicBrainz::Track
```ruby
@track = MusicBrainz::Track.find(mbid)
@track.position
@track.recording_id
@track.title
@track.length
```

### Testing
```
bundle exec rspec
```

### Debug console
```
bundle exec irb -r musicbrainz
```

### Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* **Start a feature/bugfix branch (IMPORTANT)**
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2011 Gregory Eremin. See [LICENSE](https://raw.github.com/magnolia-fan/musicbrainz/master/LICENSE) for further details.
