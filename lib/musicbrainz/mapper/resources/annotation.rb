module MusicBrainz
  module Mapper
    module Resources
      module Annotation
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :type, from: '@type'

            xml_accessor :entity, from: 'entity'
            xml_accessor :name, from: 'name'
            xml_accessor :text, from: 'text'
          end
        end
      end
    end
  end
end
