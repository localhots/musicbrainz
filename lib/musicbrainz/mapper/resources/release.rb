module MusicBrainz
  module Mapper
    module Resources
      module Release
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :title, from: 'title'
            xml_accessor :status, from: 'status'
            xml_accessor :quality, from: 'quality' # low, normal, high
            xml_accessor :disambiguation, from: 'disambiguation'
            xml_accessor :packaging, from: 'packaging'
            xml_accessor :language, from: 'text-representation/language'
            xml_accessor :script, from: 'text-representation/script'
            xml_accessor(:date, from: 'date') {|date| MusicBrainz::Mapper::Entity.to_date(date) }
            xml_accessor :country, from: 'country' # [A-Z]{2}
            xml_accessor :barcode, from: 'barcode'
            xml_accessor :asin, from: 'asin' # [A-Z0-9]{10}

            xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation
            xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]
            xml_accessor :release_group, from: 'release-group', as: MusicBrainz::ReleaseGroup
            xml_accessor :cover_art_archive, from: 'cover-art-archive', as: MusicBrainz::CoverArtArchive
            xml_accessor :label_infos, from: 'label-info-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :media, from: 'medium-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :relations, from: 'relation-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :tags, from: 'tag-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :user_tags, from: 'user-tag-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :collections, from: 'collection-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
