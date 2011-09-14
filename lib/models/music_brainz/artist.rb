module MusicBrainz
  class Artist  
    attr_accessor :id, :type, :name, :country, :date_begin, :date_end
    @release_groups
  
    def release_groups
      if @release_groups.nil? and not self.id.nil?
        @release_groups = []
        Nokogiri::XML(MusicBrainz.load(
          'http://musicbrainz.org/ws/2/release-group/?artist=' + self.id
        )).css('release-group').each do |rg|
          @release_groups << MusicBrainz::ReleaseGroup.parse_xml(rg)
        end
      end
      @release_groups.sort{ |a, b| a.first_release_date <=> b.first_release_date }
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
    
    def self.discography mbid
      artist = self.find(mbid)
      artist.release_groups.each {|rg| rg.releases.each {|r| r.tracks } }
      artist
    end
    
    def self.find_by_name name
      matches = self.search name
      matches.length.zero? ? nil : self.find(matches.first[:mbid])
    end
    
    def self.search name
      artists = []
      xml = Nokogiri::XML(MusicBrainz.load(
        'http://musicbrainz.org/ws/2/artist/?query='+ URI.escape(name).gsub(/\&/, '%26').gsub(/\?/, '%3F') +'~&limit=50'
      ))
      xml.css('artist-list > artist').each do |a|
        artist = {
          :name => a.first_element_child.text,
          :weight => 0,
          :desc => (a.css('disambiguation').text unless a.css('disambiguation').empty?),
          :type => a.attr('type'),
          :mbid => a.attr('id')
        }
        aliases = a.css('alias-list > alias').map{ |item| item.text }
        if aliases.include? name
          artist[:weight] += 20
        elsif aliases.map{ |item| item.downcase }.include? name.downcase
          artist[:weight] += 10
        elsif aliases.map{ |item| item.downcase.gsub(/\s/, '') }.include? name.downcase.gsub(/\s/, '')
          artist[:weight] += 5
        end
        artists << artist
      end
      artists.sort{ |a, b| b[:weight] <=> a[:weight] }.take(10)
    end
  end
end
