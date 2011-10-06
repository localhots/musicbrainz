module MusicBrainz
  class Base
    def self.safe_get_attr xml, path, name
      xml.css(path).first.attr(name) unless xml.css(path).empty? or xml.css(path).first.attr(name).nil?
    end
    
    def self.safe_get_value xml, path
      xml.css(path).first.text unless xml.css(path).empty?
    end
  end
end
