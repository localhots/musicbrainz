module MusicBrainz
  module Mapper
    module Resources
      module Cdstub
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :title, from: 'title'
            xml_accessor :artist, from: 'artist'
            xml_accessor :barcode, from: 'barcode'
            xml_accessor :comment, from: 'comment'

            xml_accessor :nonmb_tracks, from: 'nonmb-track-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
