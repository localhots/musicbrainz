module MusicBrainz
  class Release
    attr_accessor :id, :title, :status, :date, :country
    @tracks
  
    def tracks
      if @tracks.nil? and not self.id.nil?
        @tracks = []
        Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release/' + self.id + '?inc=recordings&limit=100')).css('medium-list > medium > track-list > track').each do |r|
          @tracks << MusicBrainz::Track.parse_xml(r)
        end
      end
      @tracks.sort{ |a, b| a.position <=> b.position }
    end
  
    def self.find mbid
      xml = Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release/' + mbid)).css('release').first
      self.parse_xml(xml) unless xml.nil?
    end
  
    def self.parse_xml xml
      @release = MusicBrainz::Release.new
      @release.id = xml.attr('id')
      @release.title = xml.css('title').text unless xml.css('title').empty?
      @release.status = xml.css('status').text unless xml.css('status').empty?
      date = xml.css('date').empty? ? '2030-12-31' : xml.css('date').text
      if date.length == 0
        date = '2030-12-31'
      elsif date.length == 4
        date += '-12-31'
      elsif date.length == 7
        date += '-31'
      end
      date = date.split('-')
      @release.date = Time.utc(date[0], date[1], date[2])
      @release.country = xml.css('country').text unless xml.css('country').empty?
      @release
    end
  end
end
