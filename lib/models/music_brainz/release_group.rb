module MusicBrainz
  class ReleaseGroup
    attr_accessor :id, :type, :title, :first_release_date
    @releases
  
    def releases
      if @releases.nil? and not self.id.nil?
        @releases = []
        Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release/?release-group=' + self.id + '&limit=100')).css('release').each do |r|
          @releases << MusicBrainz::Release.parse_xml(r)
        end
      end
      @releases
    end
  
    def self.find mbid
      xml = Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release-group/' + mbid)).css('release-group').first
      self.parse_xml(xml) unless xml.nil?
    end
  
    def self.parse_xml xml
      @release_group = MusicBrainz::ReleaseGroup.new
      @release_group.id = xml.attr('id')
      @release_group.type = xml.attr('type')
      @release_group.title = xml.css('title').text unless xml.css('title').empty?
      date = nil
      date = xml.css('first-release-date').text unless xml.css('first-release-date').empty?
      unless date.nil? or date.empty?
        if date.length == 4
          date += '-01-01'
        elsif date.length == 7
          date += '-01'
        end
        date = Time.parse(date)
      end
      @release_group.first_release_date = date
      @release_group
    end
  end
end
