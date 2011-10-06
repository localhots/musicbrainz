module MusicBrainz
  class Artist < MusicBrainz::Base
    attr_accessor :id, :type, :name, :country, :date_begin, :date_end
    @release_groups
  
    def release_groups
      if @release_groups.nil? and not self.id.nil?
        @release_groups = []
        Nokogiri::XML(MusicBrainz.load(:release_group, :artist => self.id)).css('release-group').each do |rg|
          @release_groups << MusicBrainz::ReleaseGroup.parse_xml(rg)
        end
      end
      @release_groups.sort{ |a, b| a.first_release_date <=> b.first_release_date }
    end
  
    def self.find mbid
      res = MusicBrainz.load :artist, :id => mbid
      return nil if res.nil?
      @artist = self.parse_xml(Nokogiri::XML(res))
    end
  
    def self.parse_xml xml
      @artist = MusicBrainz::Artist.new
      @artist.id = self.safe_get_attr(xml, 'artist', 'id')
      @artist.type = self.safe_get_attr(xml, 'artist', 'type')
      @artist.name = self.safe_get_value(xml, 'artist > name')
      @artist.country = self.safe_get_value(xml, 'artist > country')
      @artist.date_begin = self.safe_get_value(xml, 'artist > life-span > begin')
      @artist.date_end = self.safe_get_value(xml, 'artist > life-span > end')
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
      xml = Nokogiri::XML(MusicBrainz.load(:artist, :query => CGI.escape(name).gsub(/\!/, '') + '~', :limit => 50))
      xml.css('artist-list > artist').each do |a|
        artist = {
          :name => a.first_element_child.text,
          :weight => 0,
          :desc => self.safe_get_value(a, 'disambiguation'),
          :type => self.safe_get_attr(a, nil, 'type'),
          :mbid => self.safe_get_attr(a, nil, 'id')
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
