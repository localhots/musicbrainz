# -*- encoding: utf-8 -*-
module MusicBrainz
  class Release < MusicBrainz::Base
    attr_accessor :id, :title, :status, :format, :date, :country
    @tracks

    def tracks
      if @tracks.nil? and not self.id.nil?
        @tracks = []
        Nokogiri::XML(self.class.load(:release, :id => self.id, :inc => [:recordings, :media], :limit => 100)).css('medium-list > medium > track-list > track').each do |r|
          @tracks << MusicBrainz::Track.parse_xml(r)
        end
      end
      @tracks.sort{ |a, b| a.position <=> b.position }
    end

    def self.find mbid
      xml = Nokogiri::XML(self.load(:release, :id => mbid, :inc => [:media])).css('release').first
      self.parse_xml(xml) unless xml.nil?
    end

    def self.parse_xml xml
      @release = MusicBrainz::Release.new
      @release.id = self.safe_get_attr(xml, nil, 'id')
      @release.title = self.safe_get_value(xml, 'title')
      @release.status = self.safe_get_value(xml, 'status')
      @release.format = self.safe_get_value(xml, 'medium-list > medium > format')
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
      @release.country = self.safe_get_value(xml, 'country')
      @release
    end
  end
end
