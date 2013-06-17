module MusicBrainz
  module Mapper
    module Resources
      module CoverArtArchive
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor(:artwork, from: 'artwork') {|boolean| boolean.to_s.strip == 'true' ? true : false}
            xml_accessor :count, from: 'count', as: Integer
            xml_accessor(:front, from: 'front') {|boolean| boolean.to_s.strip == 'true' ? true : false}
            xml_accessor(:back, from: 'back') {|boolean| boolean.to_s.strip == 'true' ? true : false}
            xml_accessor(:darkened, from: 'darkened') {|boolean| boolean.to_s.strip == 'true' ? true : false}
          end
        end
      end
    end
  end
end
