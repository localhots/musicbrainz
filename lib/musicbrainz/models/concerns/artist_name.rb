module MusicBrainz
  module Concerns
    module ArtistName
      def artist_name
        name = []
        
        artists.each do |artist|
          name << artist.name
          name << artist.joinphrase unless artist.joinphrase.to_s.empty?
        end
        
        name.join('')
      end
    end
  end
end