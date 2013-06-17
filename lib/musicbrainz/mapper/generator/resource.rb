module MusicBrainz
  module Mapper
    module Generator
      class Resource
        def initialize(xml, namespace, verbose = false)
          @xml, @namespace, @verbose = xml, namespace, verbose
          @parent = @xml.xpath('parent').text
          @from_root = '../' unless @parent == ''
        end
        
        def self.create(xml, verbose)
          resource = self.new(xml, 'MusicBrainz', verbose)
          resource.open
          resource.write
          resource.close
        end
        
        def self.code(namespace, xml)
          resource = self.new(xml, namespace)
          resource.code
        end
        
        def open
          file_name = @xml.name.gsub('-', '_')
          
          if @verbose
            puts "autoload :#{Base.classify(@xml.name)}, File.expand_path('musicbrainz/mapper/resources/#{file_name}', File.dirname(__FILE__))"
          end
          
          @file = File.open(
            File.expand_path("../../../../lib/musicbrainz/mapper/resources/#{file_name}.rb", File.dirname(__FILE__)), 'w'
          )
        end
        
        def write
          @indentation = '            '
          @file.puts %Q{module MusicBrainz
  module Mapper
    module Resources
      module #{Base.classify(@xml.name)}
        def self.included(base)}
          
          if @parent == ''
            @file.puts %Q{          base.send(:include, ::MusicBrainz::Mapper::Entity)
            }
          end
          
          @file.puts %Q{          base.class_eval do
#{code}
          end
        end
      end
    end
  end
end}
        end
        
        def code
          @xml.xpath('./*').map {|xml| block(xml) }.delete_if{|item| item == '' }.join("\n\n")
        end
        
        def close; @file.close; end
        
        private
        
        def block(xml)
          xml.xpath('./*').map { |line| eval("add_#{xml.name.gsub('s', '')}(line)") }.join("\n")
        end
        
        def add_attribute(xml)
          %Q{#{@indentation}xml_accessor :#{xml.name.gsub('-', '_')}, from: '#{@from_root}@#{xml.name}'}
        end
        
        def add_element(xml)
          parent = xml.xpath('./parent').text
          is_array = xml.xpath('./is_array').text == 'true' ? true : parent.match('-list')
          from = xml.xpath('./from').text; from = from.blank? ? xml.name : from
          
          if parent.to_s == ''
            type = xml.xpath('./type/name').text
            as = ['String', 'Boolean', 'IncompleteDate'].include?(type) ? '' : ", as: #{type}"
            
            arguments = ":#{xml.name.gsub('-', '_')}, from: '#{@from_root}#{from}'#{as}"
            
            arguments = if type == 'Boolean'
              "(#{arguments}) {|boolean| boolean.to_s.strip == 'true' ? true : false}"
            elsif type == 'IncompleteDate'
              "(#{arguments}) {|date| MusicBrainz::Mapper::Entity.to_date(date) }"
            else " #{arguments}"
            end
            
            comment = xml.xpath('./type/comment').text.strip
            comment = comment.to_s == '' ? '' : " # #{comment}"
            
            "#{@indentation}xml_accessor#{arguments}#{comment}"
          else
            name, as = xml.name.gsub('-', '_'), '' 
            name, as = "#{name}s", ', as: []' if is_array 
            
            %Q{#{@indentation}xml_accessor :#{name}, from: '#{@from_root}#{parent}/#{from}'#{as}}
          end
        end
        
        def add_ref(xml)
          if xml.name == 'artist-credit'
            return "#{@indentation}xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]"  
          end
          
          accessor_name = Base.pluralize(xml.name).gsub('-', '_')
          from = xml.name; as = nil
          sought_type_argument_is_a_nodeset = ''
          
          if xml.xpath('./*').length > 0
            as = xml.xpath("./resource/name").text
            type = xml.xpath("./resource/type/name").text
            
            if type == 'String'
              from, as = "#{from}/#{as}", '[]'
            else
              as = 'MusicBrainz::Mapper::List'
              sought_type_argument_is_a_nodeset = ', sought_type_argument_is_a_nodeset: true'
            end
          else  
            as = Base.classify(xml.name, @namespace)
          end
          
          %Q{#{@indentation}xml_accessor :#{accessor_name}, from: '#{from}', as: #{as}#{sought_type_argument_is_a_nodeset}}
        end
      end
    end
  end
end