# -*- encoding: utf-8 -*-

module MusicBrainz
  class Release < Base

    field :id, String
    field :title, String
    field :status, String
    field :format, String
    field :date, Time
    field :country, String

    def tracks
      @tracks ||= nil
      if @tracks.nil? and !id.nil?
        @tracks = self.class.load({
          :parser => :release_tracks,
          :create_models => MusicBrainz::Track
        }, {
          :resource => :release,
          :id => id,
          :inc => [:recordings, :media],
          :limit => 100
        })
        @tracks.sort{ |a, b| a.position <=> b.position }
      end
      @tracks
    end

    class << self
      def find(mbid)
        load({
          :parser => :release_model,
          :create_model => MusicBrainz::Release
        }, {
          :resource => :release,
          :id => mbid,
          :inc => [:media]
        })
      end
    end
  end
end
