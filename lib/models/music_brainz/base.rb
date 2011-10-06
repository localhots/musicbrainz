module MusicBrainz
  class Base
    def self.safe_get_attr xml, path, name
      node = path.nil? ? xml : (xml.css(path).first unless xml.css(path).empty?)
      node.attr(name) unless node.nil? or node.attr(name).nil?
    end
    
    def self.safe_get_value xml, path
      xml.css(path).first.text unless xml.css(path).empty?
    end
  end
end
