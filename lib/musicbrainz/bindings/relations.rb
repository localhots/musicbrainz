# encoding: UTF-8
module MusicBrainz
  module Bindings
    module Relations
      def parse(xml)
        hash = { urls: {} }
        
        xml.xpath('./relation-list[@target-type="url"]/relation').map do |xml|
          next unless type = xml.attribute('type')
          
          type = type.value.downcase.split(" ").join("_").to_sym       
          target = xml.xpath('./target').text   
          
          if hash[:urls][type].nil? then hash[:urls][type] = target
          elsif hash[:urls][type].is_a?(Array) then hash[:urls][type] << target
          else hash[:urls][type] = [hash[:urls][type]]; hash[:urls][type] << target
          end
        end
        
        hash
      end
      
      extend self
    end
  end
end