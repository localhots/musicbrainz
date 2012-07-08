# -*- encoding: utf-8 -*-

module MusicBrainz
  class ReleaseGroup < Base

    field :id, String
    field :type, String
    field :title, String
    field :disambiguation, String
    field :first_release_date, Time

    def releases
      @releases ||= nil
      if @releases.nil? and !id.nil?
        @releases = self.class.load({
          :parser => :release_group_releases,
          :create_models => MusicBrainz::Release
        }, {
          :resource => :release,
          :release_group => self.id,
          :inc => [:media],
          :limit => 100
        })
        @releases.sort!{ |a, b| a.date <=> b.date }
      end
      @releases
    end

    class << self
      def find(mbid)
        load({
          :parser => :release_group_model,
          :create_model => MusicBrainz::ReleaseGroup
        }, {
          :resource => :release_group,
          :id => mbid
        })
      end
    end
  end
end
