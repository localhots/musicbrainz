# -*- encoding: utf-8 -*-
module MusicBrainz
  class Track < MusicBrainz::Base
    attr_accessor :position, :recording_id, :title, :length

    def self.find mbid
      xml = Nokogiri::XML(self.load(:recording, :id => mbid))
      self.parse_xml(xml) unless xml.nil?
    end

    def self.parse_xml xml
      @track = MusicBrainz::Track.new
      @track.position = self.safe_get_value(xml, 'position').to_i
      @track.recording_id = self.safe_get_attr(xml, 'recording', 'id')
      @track.title = self.safe_get_value(xml, 'recording > title')
      @track.length = self.safe_get_value(xml, 'length').to_i
      @track.length = self.safe_get_value(xml, 'recording > length').to_i
      @track
    end
  end
end
