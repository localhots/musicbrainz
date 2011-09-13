module MusicBrainz
  class Release
    attr_accessor :id, :title, :status, :date, :country
    @tracks
  
    def tracks
      if @tracks.nil? and not self.id.nil?
        @tracks = []
        Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release/' + self.id + '?inc=recordings')).css('medium-list > medium > track-list > track').each do |r|
          @tracks << MusicBrainz::Track.parse_xml(r)
        end
      end
      @tracks
    end
  
    def self.find mbid
      xml = Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release/' + mbid)).css('release').first
      self.parse_xml(xml) unless xml.nil?
    end
  
    def self.parse_xml xml
      @release = MusicBrainz::Release.new
      @release.id = xml.attr('id')
      @release.title = xml.css('title').text
      @release.status = xml.css('status').text
      date = xml.css('date').text
      unless date.nil? or date.empty?
        if date.length == 4
          date += '-01-01'
        elsif date.length == 7
          date += '-01'
        end
        date = Time.parse(date)
      end
      @release.date = date
      @release.country = xml.css('country').text
      @release
    end
  end
end
