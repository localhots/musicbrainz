module MusicBrainz
  module Mapper
    module Resources
      module Tag
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :count, from: '@count'

            xml_accessor :name, from: 'name'
          end
        end
      end
    end
  end
end
