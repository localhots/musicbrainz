module MusicBrainz
  module Mapper
    module Resources
      module Track
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :position, from: 'position', as: Integer
            xml_accessor :number, from: 'number'
            xml_accessor :title, from: 'title'
            xml_accessor :length, from: 'length', as: Integer

            xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
            xml_accessor :recording, from: 'recording', as: MusicBrainz::Recording
          end
        end
      end
    end
  end
end
