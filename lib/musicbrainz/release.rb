# -*- encoding: utf-8 -*-
module MusicBrainz
  class Release < MusicBrainz::Base

    field :id, String
    field :title, String
    field :status, String
    field :format, String
    field :date, Time
    field :country, String

    def tracks
      if @tracks.nil? and not self.id.nil?
        @tracks = []
        Nokogiri::XML(self.class.load(:release, :id => self.id, :inc => [:recordings, :media], :limit => 100)).css('medium-list > medium > track-list > track').each do |r|
          @tracks << MusicBrainz::Track.parse_xml(r)
        end
      end
      @tracks.sort{ |a, b| a.position <=> b.position }
    end

    class << self
      def find(mbid)
        xml = Nokogiri::XML(self.load(:release, :id => mbid, :inc => [:media])).css('release').first
        self.parse_xml(xml) unless xml.nil?
      end
    end
  end
end
