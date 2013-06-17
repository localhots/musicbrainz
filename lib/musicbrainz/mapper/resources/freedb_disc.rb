module MusicBrainz
  module Mapper
    module Resources
      module FreedbDisc
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :title, from: 'title'
            xml_accessor :artist, from: 'artist'
            xml_accessor :category, from: 'category'
            xml_accessor :year, from: 'year' # [0-9]{4}

            xml_accessor :nonmb_tracks, from: 'nonmb-track-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
