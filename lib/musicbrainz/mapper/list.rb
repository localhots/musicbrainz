module MusicBrainz
  module Mapper
    class List < Array
      attr_accessor *[
        :offset, :total_count, # def_list-attributes
        # custom lists
        :track_count # def_medium-list
      ]
      
      def self.from_xml(xml, options = {})
        lists = if xml.is_a?(String)
          [Nokogiri.parse(strip(xml))]
        elsif xml.is_a?(Array) || xml.is_a?(Nokogiri::XML::NodeSet)
          xml
        else 
          [xml]
        end.select{|list| !list.nil? }
         
        return [] if lists.none? 
        
        if xml.is_a?(String)
          xml_element = lists.first.children.first
          
          unless xml_element.name.match('-list')
            raise NotImplementedError.new("List tag name should match '*-list' but got #{xml_element.name.inspect}")
          end
           
          working_lists = Nokogiri.parse("<resource>#{strip(xml)}</resource>").xpath("resource/#{xml_element.name}")
          
          lists = working_lists.length > 1 ? working_lists : [xml_element]
          
          return [] if lists.none?
        elsif lists.first.children.any? && lists.first.children.first.name == 'relation-list'
          raise NotImplementedError.new(
            'Passing a nokogiri instance of relation-list to MusicBrainz::List.from_xml is not supported yet.'
          )
        end
        
        resource_name, resources = lists.first.name.split('-list').first, []
        resource_class = classify(resource_name)
        
        lists.each do |xml_element|
          unless xml_element.name.match('-list')
            raise NotImplementedError.new("List tag name should match '*-list' but got #{xml_element.name.inspect}")
          end
          
          resources += xml_element.xpath(resource_name).map do |r| 
            r = ::MusicBrainz::const_get(resource_class).from_xml(r)
            r.target_type = xml_element.attribute('target-type').value rescue nil if r.respond_to? :target_type
            r
          end
        end
        
        list = self.new(resources)
        list.map_list_attributes(lists.first) if lists.length == 1
        
        list
      end
      
      #  maps def_list-attributes or def_medium-list
      def map_list_attributes(xml)
        self.offset = xml.attribute('offset').value rescue nil
        self.total_count = xml.attribute('count').value rescue nil
        self.track_count = xml.xpath('track-count').text rescue nil
      end
      
      def [](target_type)
        unless first.respond_to? :target_type
          raise NotImplementedError.new('List item does not respond to target_type')
        end
        
        select{|resource| resource.target_type == target_type }
      end
  
      def keys
        unless first.respond_to? :target_type
          raise NotImplementedError.new('List item does not respond to target_type')
        end
        
        map(&:target_type).uniq
      end
      
      def to_primitive; map(&:to_primitive); end
      
      private
  
      def offset=(value); @offset = value.to_i; end
      def total_count=(value); @total_count = value.to_i; end
      def track_count=(value); @track_count = value.to_i; end
      
      def self.strip(xml)
        xml.strip.split("\n").map(&:strip).join('')
      end
      
      def self.classify(string)
        string.split('-').map(&:capitalize).join('')
      end
    end
  end
end