# -*- encoding: utf-8 -*-
module MusicBrainz
  class ReleaseGroup < MusicBrainz::Base
    attr_accessor :id, :type, :title, :disambiguation, :first_release_date
    @releases

    def releases
      if @releases.nil? and not self.id.nil?
        @releases = []
        Nokogiri::XML(self.class.load(:release, :release_group => self.id, :inc => [:media], :limit => 100)).css('release').each do |r|
          @releases << MusicBrainz::Release.parse_xml(r)
        end
      end
      @releases.sort{ |a, b| a.date <=> b.date }
    end

    def self.find mbid
      xml = Nokogiri::XML(self.load(:release_group, :id => mbid)).css('release-group').first
      self.parse_xml(xml) unless xml.nil?
    end

    def self.parse_xml xml
      @release_group = MusicBrainz::ReleaseGroup.new
      @release_group.id = self.safe_get_attr(xml, nil, 'id')
      @release_group.type = self.safe_get_attr(xml, nil, 'type')
      @release_group.title = self.safe_get_value(xml, 'title')
      @release_group.disambiguation = self.safe_get_value(xml, 'disambiguation')
      date = xml.css('first-release-date').empty? ? '2030-12-31' : xml.css('first-release-date').text
      if date.length == 0
        date = '2030-12-31'
      elsif date.length == 4
        date += '-12-31'
      elsif date.length == 7
        date += '-31'
      end
      date = date.split('-')
      @release_group.first_release_date = Time.utc(date[0], date[1], date[2])
      @release_group
    end
  end
end
