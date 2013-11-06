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
  :id         => String,
  :type       => String,
  :name       => String,
  :country    => String,
  :date_begin => Date,
  :date_end   => Date,
  :urls       => Hash
}
```

MusicBrainz::ReleaseGroup
```ruby
# Class Methods
MusicBrainz::ReleaseGroup.find(id)
MusicBrainz::ReleaseGroup.find_by_artist_and_title(artist_name, title, 'Album') # 3rd arg optional
MusicBrainz::ReleaseGroup.search(artist_name, title)
MusicBrainz::ReleaseGroup.search(artist_name, title, 'Album') # 3rd arg optional

# Instance Methods
@release_group.releases

# Fields
{
  :id                 => String,
  :type               => String,
  :title              => String,
  :desc               => String,
  :first_release_date => Date,
  :urls               => Hash
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
  :id      => String,
  :type    => String,
  :title   => String,
  :status  => String,
  :format  => String,
  :date    => Date,
  :country => String,
  :asin    => String,
  :barcode => String,
  :quality => String
}
```

MusicBrainz::Track (depreciated, now called Recording)
```ruby
# Class Methods
MusicBrainz::Track.find(id)

# Fields
{
  :position     => Integer,
  :recording_id => String,
  :title        => String,
  :length       => Integer
}
```

MusicBrainz::Recording
```ruby
# Class Methods
MusicBrainz::Recording.find(id)
MusicBrainz::Recording.search(track_name, artist_name)

# Fields
{
  :id     	=> Integer,
  :mbid			=> Integer,
  :title		=> String,
  :artist		=> String,
	:releases	=> String,
	:score		=> Integer
}
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

Copyright (c) 2014 Gregory Eremin. See [LICENSE](https://raw.github.com/magnolia-fan/musicbrainz/master/LICENSE) for further details.
