module MusicBrainz
  module Mapper
    module Entity
      def self.included(base)
        base.send(:include, ROXML)
        base.send(:include, SearchResult)
        
        base.class_eval do
          attr_accessor :target_type
        end
      end
      
      def self.to_date(val)
        val = if val.nil? or val == ""
          [2030, 12, 31]
        elsif val.split("-").length == 1
          [val.split("-").first.to_i, 12, 31]
        elsif val.split("-").length == 2
          val = val.split("-").map(&:to_i)
          [val.first, val.last, -1]
        else
          val.split("-").map(&:to_i)
        end
        
        Date.new(*val)
      end
      
      def to_primitive
        do_not_search = true
        
        hash = {}
        
        self.class.roxml_attrs.each do |roxml_attr|
          value = send(roxml_attr.attr_name)
         
          if value.is_a?(MusicBrainz::Mapper::List)
            hash["#{roxml_attr.attr_name}_count".to_sym] = value.total_count
          end
         
          next if value.nil? || (value.is_a?(String) && value == '') || (value.is_a?(Integer) && value == 0)
          next if (value.is_a?(Array) || value.is_a?(MusicBrainz::Mapper::List)) && value.none?

          hash[roxml_attr.attr_name.to_sym] = if value.is_a?(MusicBrainz::Mapper::List) then value.to_primitive
          elsif value.is_a?(Array)
            value.map {|resource| resource.respond_to?(:to_primitive) ? resource.to_primitive : resource }
          elsif value.respond_to?(:to_primitive) then value.to_primitive
          else value
          end
        end
        
        hash
      end
    end
  end
end