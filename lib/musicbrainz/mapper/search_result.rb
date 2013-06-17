module MusicBrainz
  module Mapper
    module SearchResult
      def self.included(base)
        base.class_eval { xml_accessor :score, from: "@score", as: Integer }
      end
    end
  end
end