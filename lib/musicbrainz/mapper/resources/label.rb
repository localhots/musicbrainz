module MusicBrainz
  module Mapper
    module Resources
      module Label
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'
            xml_accessor :type, from: '@type'

            xml_accessor :name, from: 'name'
            xml_accessor :sort_name, from: 'sort-name'
            xml_accessor :label_code, from: 'label-code', as: Integer
            xml_accessor :ipi, from: 'ipi' # [0-9]{11}
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor :country, from: 'country' # [A-Z]{2}
            xml_accessor :begin, from: 'life-span/begin'
            xml_accessor :end, from: 'life-span/end'
            xml_accessor :user_rating, from: 'user-rating', as: Integer

            xml_accessor :ipis, from: 'ipi-list/ipi', as: []
            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :aliases, from: 'alias-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
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
