require File.expand_path('../lib/musicbrainz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gregory Eremin"]
  gem.email         = ["magnolia_fan@me.com"]
  gem.summary       = %q{ MusicBrainz Web Service wrapper with ActiveRecord-style models }
  gem.homepage      = "http://github.com/magnolia-fan/musicbrainz"

  gem.files         = %x{ git ls-files }.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "musicbrainz"
  gem.require_paths = %w[ lib ]
  gem.version       = MusicBrainz::VERSION
  gem.license       = "MIT"

  gem.add_runtime_dependency('faraday')
  gem.add_runtime_dependency('nokogiri')
end
