module MusicBrainz
  module Mapper
    module Resources
      module Artist
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'
            xml_accessor :type, from: '@type'

            xml_accessor :name, from: 'name'
            xml_accessor :sort_name, from: 'sort-name'
            xml_accessor :gender, from: 'gender'
            xml_accessor :country, from: 'country' # [A-Z]{2}
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor :ipi, from: 'ipi' # [0-9]{11}
            xml_accessor :begin, from: 'life-span/begin'
            xml_accessor :end, from: 'life-span/end'
            xml_accessor :user_rating, from: 'user-rating', as: Integer

            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :ipis, from: 'ipi-list/ipi', as: []
            xml_accessor :aliases, from: 'alias-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :recordings, from: 'recording-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :releases, from: 'release-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :release_groups, from: 'release-group-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :labels, from: 'label-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :works, from: 'work-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
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
