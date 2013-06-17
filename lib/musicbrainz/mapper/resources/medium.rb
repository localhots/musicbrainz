module MusicBrainz
  module Mapper
    module Resources
      module Medium
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :title, from: 'title'
            xml_accessor :position, from: 'position', as: Integer
            xml_accessor :format, from: 'format'

            xml_accessor :discs, from: 'disc-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
            xml_accessor :tracks, from: 'track-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
