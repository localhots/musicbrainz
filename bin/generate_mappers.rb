require File.expand_path('../lib/musicbrainz.rb', File.dirname(__FILE__))

MusicBrainz::Mapper::Generator::Base.run(true)

puts 'Successfully generated ruby mappers under lib/musicbrainz/mapper/resources/*.rb and models under lib/musicbrainz/models'