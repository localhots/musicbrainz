module MusicBrainz
  @@last_query_time = 0
  
  def self.last_query_time
    @@last_query_time
  end
  
  def self.last_query_time= time
    @@last_query_time = time
  end

  def self.load url
    sleep 1.1 - (Time.now.to_f - self.last_query_time) if Time.now.to_f - self.last_query_time < 1.1
    response = nil
    5.times do
      begin
        response = open(url, "User-Agent" => "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname)
        self.last_query_time = Time.now.to_f
      rescue => e
        p "MusicBrainz: 503"
      end
      break unless response.nil?
    end
    response
  end
  
  def self.discography mbid
    artist = MusicBrainz::Artist.find(mbid)
    artist.release_groups.each {|rg| rg.releases.each {|r| r.tracks } }
    artist
  end
end
