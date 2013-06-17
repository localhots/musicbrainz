module MusicBrainz
  module Mapper
    module Resources
      module ReleaseGroup
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'
            xml_accessor :type, from: '@type'

            xml_accessor :title, from: 'title'
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor(:first_release_date, from: 'first-release-date') {|date| MusicBrainz::Mapper::Entity.to_date(date) }
            xml_accessor :primary_type, from: 'primary-type'
            xml_accessor :secondary_types, from: 'secondary-type-list/secondary-type', as: []
            xml_accessor :user_rating, from: 'user-rating', as: Integer

            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
            xml_accessor :releases, from: 'release-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
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
