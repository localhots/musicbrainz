# -*- encoding: utf-8 -*-

module MusicBrainz
  module Tools
    class Proxy
      class << self
        @@last_query_time = 0

        def config
          MusicBrainz.config
        end

        def query_interval=(sec)
          config.query_interval = sec.to_f
        end

        def tries_limit=(num)
          config.tries_limit = num.to_i
        end

        def query(params = {})
          url = config.web_service_url + params[:resource].to_s.gsub('_', '-') + '/' + (params[:id].to_s || '')
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

          config.tries_limit.times {
            time_passed = Time.now.to_f - @@last_query_time
            sleep(config.query_interval - time_passed) if time_passed < config.query_interval

            begin
              response = open(url, "User-Agent" => config.user_agent)
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
