module MusicBrainz
  module Mapper
    module Resources
      module Relation
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :type, from: '@type'
            xml_accessor :type_id, from: '@type-id'

            xml_accessor :target, from: 'target'
            xml_accessor :direction, from: 'direction' # both, forward, backward
            xml_accessor(:begin, from: 'begin') {|date| MusicBrainz::Mapper::Entity.to_date(date) }
            xml_accessor(:end, from: 'end') {|date| MusicBrainz::Mapper::Entity.to_date(date) }
            xml_accessor(:ended, from: 'ended') {|boolean| boolean.to_s.strip == 'true' ? true : false}

            xml_accessor :attributes, from: 'attribute-list/attribute', as: []
            xml_accessor :artist, from: 'artist', as: MusicBrainz::Artist
            xml_accessor :release, from: 'release', as: MusicBrainz::Release
            xml_accessor :release_group, from: 'release-group', as: MusicBrainz::ReleaseGroup
            xml_accessor :recording, from: 'recording', as: MusicBrainz::Recording
            xml_accessor :label, from: 'label', as: MusicBrainz::Label
            xml_accessor :work, from: 'work', as: MusicBrainz::Work
          end
        end
      end
    end
  end
end
