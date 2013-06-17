## MusicBrainz Web Service wrapper [![Travis CI](https://secure.travis-ci.org/magnolia-fan/musicbrainz.png)](http://travis-ci.org/magnolia-fan/musicbrainz)

### Ruby Version
**IMPORTANT!**

Ruby version 1.9+ required. No support for 1.8.7 anymore, if you still on 1.8 consider using gem [version 0.5.2](https://github.com/magnolia-fan/musicbrainz/tree/v0.5.2#musicbrainz-web-service-wrapper-) and bundle it like this:

```ruby
gem 'musicbrainz', '0.5.2'
```

### Installation
```
gem install musicbrainz
```
or add this line to your Gemfile
```ruby
gem 'musicbrainz'
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
  c.hexdigest_url = true # not sure if secure in production but set to false if you want to put cached files under a directory schema which matches the query
  
  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end
```

### Usage
```ruby
require 'musicbrainz'

# Search for artists
@suggestions = MusicBrainz::Artist.search("Jet")

# Find artist by name or mbid
@foo_fighters = MusicBrainz::Artist.find_by_name("Foo Fighters")
@kasabian = MusicBrainz::Artist.find("69b39eab-6577-46a4-a9f5-817839092033")

# Use them like ActiveRecord models
@empire_tracks = @kasabian.release_groups[8].releases.first.tracks
```

### Models

MusicBrainz::Artist
```ruby
# Class Methods:
MusicBrainz::Artist.find(id)
MusicBrainz::Artist.find_by_name(name)
MusicBrainz::Artist.search(name)
MusicBrainz::Artist.discography(id)

# Instance Methods:
@artist.release_groups

# Fields
{
  :id             => String,
  :type           => String,
  :name           => String,
  :sort_name      => String,
  :gender         => String,
  :disambiguation => String,
  :country        => String,
  :date_begin     => Date,
  :date_end       => Date,
  :urls           => Hash # will be removed in 1.0. Use :relations => { :url => {...} } instead,
  :relations      => Hash,
  :tags           => Array
}
```

MusicBrainz::ReleaseGroup
```ruby
# Class Methods
MusicBrainz::ReleaseGroup.find(id)
MusicBrainz::ReleaseGroup.find_by_artist_and_title(artist_name, title, type: 'Album')
MusicBrainz::ReleaseGroup.search(artist_name, title)
MusicBrainz::ReleaseGroup.search(artist_name, title, type: 'Album')

# Instance Methods
@release_group.releases

# Fields
{
  :id                 => String,
  :type               => String,
  :title              => String,
  :desc               => String,
  :first_release_date => Date,
  :urls               => Hash # will be removed in 1.0. Use :relations => { :url => {...} } instead,
  :relations          => Hash,
  :tags               => Array
}
```

MusicBrainz::Release
```ruby
# Class Methods
MusicBrainz::Release.find(id)

# Instance Methods
@release.tracks

# Fields
{
  :id         => String,
  :type       => String,
  :title      => String,
  :status     => String,
  :format     => String,
  :date       => Date,
  :country    => String,
  :asin       => String,
  :barcode    => String,
  :quality    => String,
  :urls       => Hash # will be removed in 1.0. Use :relations => { :url => {...} } instead,
  :relations  => Hash,
  :media      => Hash
}
```

MusicBrainz::Recording

```ruby
# Class Methods
MusicBrainz::Recording.find(id)
MusicBrainz::Recording.find_by_artist_and_title(artist_name, title, type: 'Album')
MusicBrainz::Recording.search(artist_name, title)
MusicBrainz::Recording.search(artist_name, title, type: 'Album')

# Fields
{
  :id           => String,
  :artists      => Array, // use MusicBrainz::Recording#artist_name to concat artist name(s) with joinphrase
  :title        => String,
  :length       => Integer,
  :urls         => Hash # will be removed in 1.0. Use :relations => { :url => {...} } instead,
  :relations    => Hash,
  :tags         => Array
}
```

MusicBrainz::Track (DEPRECATED: use MusicBrainz::Recording instead)

```ruby
# Class Methods
MusicBrainz::Track.find(id)

# Fields
{
  :position     => Integer,
  :recording_id => String,
  :recording    => MusicBrainz::Recording
  :artists      => Array
  :title        => String,
  :length       => Integer,
  :urls         => Hash # will be removed in 1.0. Use :relations => { :url => {...} } instead,
  :relations    => Hash
}
```

### MusicBrainz's XML Web Service 2.0 Reference

http://musicbrainz.org/doc/Development/XML_Web_Service/Version_2

http://svn.musicbrainz.org/mmd-schema/trunk/schema/musicbrainz_mmd-2.0.rng

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
