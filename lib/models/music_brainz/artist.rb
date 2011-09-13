module MusicBrainz
  class Artist  
    attr_accessor :id, :type, :name, :country, :date_begin, :date_end
    @release_groups
  
    def release_groups
      if @release_groups.nil? and not self.id.nil?
        @release_groups = []
        Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/release-group/?artist=' + self.id)).css('release-group').each do |rg|
          @release_groups << MusicBrainz::ReleaseGroup.parse_xml(rg)
        end
      end
      @release_groups
    end
  
    def self.find mbid
      @artist = self.parse_xml(Nokogiri::XML(MusicBrainz.load('http://musicbrainz.org/ws/2/artist/' + mbid)))
    end
  
    def self.parse_xml xml
      @artist = MusicBrainz::Artist.new
      @artist.id = xml.css('artist').attr('id').value
      @artist.type = xml.css('artist').attr('type').value
      @artist.name = xml.css('artist > name').text
      @artist.country = xml.css('artist > country').text unless xml.css('artist > country').empty?
      @artist.date_begin = xml.css('artist > life-span > begin').text unless xml.css('artist > life-span > begin').empty?
      @artist.date_end = xml.css('artist > life-span > end').text unless xml.css('artist > life-span > end').empty?
      @artist
    end
  end
end
