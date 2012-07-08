# -*- encoding: utf-8 -*-

module MusicBrainz
  module Tools
    class Proxy
      class << self
        @@last_query_time = 0
        @@query_interval = 1.5 # Min: 1.0 Safe: 1.5
        @@tries_limit = 5

        WEB_SERVICE_URL = 'http://musicbrainz.org/ws/2/'
        USER_AGENT = "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname

        def query_interval=(sec)
          @@query_interval = sec.to_f
        end

        def query_interval
          @@query_interval
        end

        def tries_limit=(num)
          @@tries_limit = num.to_i
        end

        def query(params = {})
          url = WEB_SERVICE_URL + params[:resource].to_s.gsub('_', '-') + '/' + (params[:id].to_s || '')
          params.delete(:resource)
          params.delete(:id) unless params[:id].nil?
          url << '?' + params.map{ |k, v|
            k = k.to_s.gsub('_', '-')
            v = (v.is_a?(Array) ? v.map{ |_| _.to_s.gsub('_', '-') }.join('+') : v.to_s)
            k + '=' + v
          }.join('&') unless params.empty?
          MusicBrainz::Tools::Cache.cache_contents(url) {
            get_contents url
          }
        end

        def get_contents(url)
          response = nil

          @@tries_limit.times {
            time_passed = Time.now.to_f - @@last_query_time
            sleep(@@query_interval - time_passed) if time_passed < @@query_interval

            begin
              response = open(url, "User-Agent" => USER_AGENT)
              @@last_query_time = Time.now.to_f
            rescue => e
              response = nil if e.io.status[0].to_i == 404
            end

            break unless response.nil?
          }

          response
        end
      end
    end
  end
end
