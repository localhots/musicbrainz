module MusicBrainz
  module Mapper
    module Resources
      module Url
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :id, from: '@id'

            xml_accessor :resource, from: 'resource'

            xml_accessor :relations, from: 'relation-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
          end
        end
      end
    end
  end
end
