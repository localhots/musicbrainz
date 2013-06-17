module MusicBrainz
  module Mapper
    module Resources
      module Work
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'
            xml_accessor :type, from: '@type'

            xml_accessor :title, from: 'title'
            xml_accessor :language, from: 'language' # [a-z]{3}
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor :iswc, from: 'iswc' # [A-Z]-[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]
            xml_accessor :user_rating, from: 'user-rating', as: Integer

            xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
            xml_accessor :iswcs, from: 'iswc-list/iswc', as: []
            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :aliases, from: 'alias-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
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
