module MusicBrainz
  class Track
    attr_accessor :position, :recording_id, :title, :length
  
    def self.find mbid
      xml = Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/recording/' + mbid))
      self.parse_xml(xml) unless xml.nil?
    end
  
    def self.parse_xml xml
      @track = MusicBrainz::Track.new
      @track.position = xml.css('position').text.to_i || nil
      @track.recording_id = xml.css('recording').attr('id').value
      @track.title = xml.css('recording > title').text
      @track.length = xml.css('length').first.text.to_i || 0
      @track
    end
  end
end
