module MusicBrainz
  module Mapper
    module Generator
      class Base
        def self.run(verbose = false)
          schema.xpath('/schema/*').each {|xml| Model.find_or_create(xml, verbose) }
          schema.xpath('/schema/*').each {|xml| Resource.create(xml, verbose) }
        end

        def self.reset_schema; @@schema = nil; end
        
        def self.classify(string, namespace = '')
          string = string.split('-').map(&:capitalize).join('')
          
          namespace == '' ? string : [namespace, string].join('::')
        end
        
        def self.pluralize(name)
          name = name.gsub('s-list', 'ses').gsub('-list', 's')
          
          case name
          when 'mediums' then 'media'
          else name
          end
        end
        
        private
        
        def self.schema
          @@schema ||= Nokogiri.parse(
            Faraday.new.get('https://raw.github.com/Applicat/music_brainz_xsl/0.0.1/schema/musicbrainz.xml').body
          )
        end
      end
    end
  end
end