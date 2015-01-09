require File.expand_path('../lib/musicbrainz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gregory Eremin"]
  gem.email         = ["magnolia_fan@me.com"]
  gem.summary       = %q{ MusicBrainz Web Service wrapper with ActiveRecord-style models }
  gem.homepage      = "http://github.com/magnolia-fan/musicbrainz"

  gem.files         = Dir['README.md', 'LICENSE', 'lib/**/*']
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "musicbrainz"
  gem.require_paths = %w[ lib ]
  gem.version       = MusicBrainz::VERSION
  gem.license       = "MIT"

  gem.add_dependency 'faraday'
  gem.add_dependency 'roxml', '~> 3.3.1'
  gem.add_dependency 'nokogiri', '~> 1.6.5' # '1.5.9' # 1.6.0 from '@score' is not compatible with ext:score="100" anymore
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'simplecov'
end
