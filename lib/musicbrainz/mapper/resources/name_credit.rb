module MusicBrainz
  module Mapper
    module Resources
      module NameCredit
        def self.included(base)
          base.class_eval do
            xml_accessor :joinphrase, from: '../@joinphrase'
          end
        end
      end
    end
  end
end
