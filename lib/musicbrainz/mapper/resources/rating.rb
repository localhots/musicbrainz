module MusicBrainz
  module Mapper
    module Resources
      module Rating
        def self.included(base)
          base.send(:include, ::MusicBrainz::Mapper::Entity)
            
          base.class_eval do
            xml_accessor :votes_count, from: '@votes-count'
          end
        end
      end
    end
  end
end
