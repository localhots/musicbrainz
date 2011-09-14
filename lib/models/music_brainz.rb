module MusicBrainz
  @@last_query_time = 0
  @@query_interval = 1.5 # Min: 1.0 Safe: 1.5
  
  def self.query_interval sec
    @@query_interval = sec.to_f
  end

  def self.load url
    sleep @@query_interval - (Time.now.to_f - @@last_query_time) if Time.now.to_f - @@last_query_time < @@query_interval
    response = nil
    5.times do
      begin
        response = open(url, "User-Agent" => "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname)
        @@last_query_time = Time.now.to_f
      rescue => e
        # MusicBrainz: 503
      end
      break unless response.nil?
    end
    response
  end
end
