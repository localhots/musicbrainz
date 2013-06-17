module MusicBrainz
  module Mapper
    module Resources
      module LabelInfo
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :catalog_number, from: 'catalog-number'

            xml_accessor :label, from: 'label', as: MusicBrainz::Label
          end
        end
      end
    end
  end
end
