# -*- encoding: utf-8 -*-

module MusicBrainz
  class Artist < Base

    field :id, String
    field :type, String
    field :name, String
    field :country, String
    field :date_begin, Time
    field :date_end, Time
    field :urls, Hash

    def release_groups
      @release_groups ||= nil
      if @release_groups.nil? and !id.nil?
        @release_groups = self.class.load({
          :parser => :artist_release_groups,
          :create_models => MusicBrainz::ReleaseGroup
        }, {
          :resource => :release_group,
          :artist => id
        })
        @release_groups.sort!{ |a, b| a.first_release_date <=> b.first_release_date }
      end
      @release_groups
    end

    class << self
      def find(mbid)
        load({
          :parser => :artist_model,
          :create_model => MusicBrainz::Artist
        }, {
          :resource => :artist,
          :id => mbid,
          :inc => [:url_rels]
        })
      end

      def search(name)
        artists = load({
          :parser => :artist_search
        }, {
          :resource => :artist,
          :query => CGI.escape(name).gsub(/\!/, '\!') + '~',
          :limit => 50
        })

        artists.each { |artist|
          if artist[:name].downcase == name.downcase
            artist[:weight] += 80
          elsif artist[:name].downcase.gsub(/\s/, "") == name.downcase.gsub(/\s/, "")
            artist[:weight] += 25
          elsif artist[:aliases].include? name
            artist[:weight] += 20
          elsif artist[:aliases].map { |item| item.downcase }.include?(name.downcase)
            artist[:weight] += 10
          elsif artist[:aliases].map { |item| item.downcase.gsub(/\s/, "") }.include?(name.downcase.gsub(/\s/, ""))
            artist[:weight] += 5
          end
        }
        artists.sort{ |a, b| b[:weight] <=> a[:weight] }.take(10)
      end

      def discography(mbid)
        artist = find(mbid)
        artist.release_groups.each { |rg| rg.releases.each { |r| r.tracks } }
        artist
      end

      def find_by_name(name)
        matches = search(name)
        matches.length.zero? ? nil : find(matches.first[:mbid])
      end
    end
  end
end
