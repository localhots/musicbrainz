module MusicBrainz
  module Mapper
    module Resources
      module Disc
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :sectors, from: 'sectors', as: Integer

            xml_accessor :releases, from: 'release-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
