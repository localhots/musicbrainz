module MusicBrainz
  @@last_query_time = 0
  @@query_interval = 1.5 # Min: 1.0 Safe: 1.5
  @@cache_path = nil
  
  WEB_SERVICE_URL = 'http://musicbrainz.org/ws/2/'
  USER_AGENT = "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname
  
  def self.query_interval= sec
    @@query_interval = sec.to_f
  end
  
  def self.cache_path= path
    @@cache_path = path
  end
  
  def self.load resourse, params = {}
    url = WEB_SERVICE_URL + resourse.to_s.gsub('_', '-') + '/' + (params[:id].to_s || '')
    params.delete(:id) unless params[:id].nil?
    url << '?' + params.map{ |k, v|
      k.to_s.gsub('_', '-') + '=' + (v.is_a?(Array) ? v.map{ |_| _.to_s.gsub('_', '-') }.join('+') : v.to_s)
    }.join('&') unless params.empty?
    self.cache_contents(url) do 
      self.get_contents url
    end
  end
  
  def self.clear_cache
    FileUtils.rm_r(@@cache_path) if @@cache_path && File.exist?(@@cache_path)
  end
  
private

  def self.cache_contents url
    response = nil
    url_parts = url.split('/')
    file_name = url_parts.pop
    directory = url_parts.pop
    file_path = @@cache_path ? "#{@@cache_path}/#{directory}/#{file_name}" : nil
        
    if file_path && File.exist?(file_path)
      response = File.open(file_path).gets
    else
      response = yield
        
      unless response.nil? || file_path.nil?
        FileUtils.mkdir_p file_path.split('/')[0..-2].join('/')
        file = File.new(file_path, 'w')
        file.puts(response.gets.force_encoding('UTF-8'))
        file.chmod(0755)
        file.close
        response.rewind
      end
    end
    
    response
  end

  def self.get_contents url
    response = nil
    
    5.times do
      time_passed = Time.now.to_f - @@last_query_time
      sleep @@query_interval - time_passed if time_passed < @@query_interval
      
      begin
        response = open(url, "User-Agent" => USER_AGENT)
        @@last_query_time = Time.now.to_f
      rescue => e
        response = nil if e.io.status[0].to_i == 404
      end
      
      break unless response.nil? 
    end
    
    response
  end
end