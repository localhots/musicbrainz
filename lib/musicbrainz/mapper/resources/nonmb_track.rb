module MusicBrainz
  module Mapper
    module Resources
      module NonmbTrack
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :title, from: 'title'
            xml_accessor :artist, from: 'artist'
            xml_accessor :length, from: 'length', as: Integer
          end
        end
      end
    end
  end
end
