module MusicBrainz
  module Mapper
    module Resources
      module Recording
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :title, from: 'title'
            xml_accessor :length, from: 'length', as: Integer
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor :user_rating, from: 'user-rating', as: Integer

            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
            xml_accessor :releases, from: 'release-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :puids, from: 'puid-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :isrcs, from: 'isrc-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :relations, from: 'relation-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :tags, from: 'tag-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :user_tags, from: 'user-tag-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :rating, from: 'rating', as: MusicBrainz::Rating
          end
        end
      end
    end
  end
end
