module MusicBrainz
  class Track
    attr_accessor :position, :recording_id, :title, :length
  
    def self.find mbid
      xml = Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/recording/' + mbid + '?limit=100'))
      self.parse_xml(xml) unless xml.nil?
    end
  
    def self.parse_xml xml
      @track = MusicBrainz::Track.new
      @track.position = xml.css('position').text.to_i unless xml.css('position').empty?
      @track.recording_id = xml.css('recording').attr('id').value unless xml.css('recording').empty?
      @track.title = xml.css('recording > title').text unless xml.css('recording > title').empty?
      @track.length = xml.css('length').first.text.to_i unless xml.css('length').empty?
      @track.length = xml.css('recording > length').first.text.to_i unless xml.css('recording > length').empty?
      @track
    end
  end
end
