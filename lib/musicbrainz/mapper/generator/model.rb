module MusicBrainz
  module Mapper
    module Generator
      class Model
        def initialize(xml, verbose)
          @xml, @verbose = xml, verbose
          @parent = @xml.xpath('parent').text
          @parent = @parent == '' ? ' < BaseModel' : " < #{Base.classify(@parent)}"
        end
        
        def self.find_or_create(xml, verbose)
          model = self.new(xml, verbose)
          
          unless model.exist?
            model.open
            model.write
            model.close
          end
        end
        
        def path
          return @path if @path
          
          file_name = @xml.name.gsub('-', '_')
          
          if @verbose
            puts "autoload :#{Base.classify(@xml.name)}, File.expand_path('musicbrainz/models/#{file_name}', File.dirname(__FILE__))"
          end
          
          @path = File.expand_path("../../../../lib/musicbrainz/models/#{file_name}.rb", File.dirname(__FILE__))
        end
        
        def exist?; File.exist?(path); end
        
        def open; @file = File.open(path, 'w'); end
        
        def write
          @file.puts %Q{module MusicBrainz
  class #{Base.classify(@xml.name)}#{@parent}
    include Mapper::Resources::#{Base.classify(@xml.name)}
  end
end}
        end
        
        def close; @file.close; end
      end
    end
  end
end