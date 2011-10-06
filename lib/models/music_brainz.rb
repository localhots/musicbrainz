module MusicBrainz
  @@last_query_time = 0
  @@query_interval = 1.5 # Min: 1.0 Safe: 1.5
  
  WEB_SERVICE_URL = 'http://musicbrainz.org/ws/2/'
  USER_AGENT = "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname
  
  def self.query_interval= sec
    @@query_interval = sec.to_f
  end
  
  def self.load resourse, params = {}
    url = WEB_SERVICE_URL + resourse.to_s.gsub('_', '-') + '/' + (params[:id].to_s || '')
    params.delete(:id) unless params[:id].nil?
    url << '?' + params.map{ |k, v|
      k.to_s.gsub('_', '-') + '=' + (v.is_a?(Array) ? v.map{ |_| _.to_s.gsub('_', '-') }.join(',') : v.to_s)
    }.join('&') unless params.empty?
    self.get_contents url
  end
  
private

  def self.get_contents url
    time_passed = Time.now.to_f - @@last_query_time
    sleep @@query_interval - time_passed if time_passed < @@query_interval
    response = nil
    5.times do
      begin
        response = open(url, "User-Agent" => USER_AGENT)
        @@last_query_time = Time.now.to_f
      rescue => e
        return nil if e.io.status[0].to_i == 404
      end
      break unless response.nil?
    end
    response
  end
end
