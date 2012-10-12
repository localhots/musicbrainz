module MusicBrainz
  module ClientModules
    module FailsafeProxy
      def get_contents(url)
        response = nil

        MusicBrainz.config.tries_limit.times do
          time_passed = Time.now.to_f - @last_query_time ||= 0.0
          if time_passed < MusicBrainz.config.query_interval
            sleep(MusicBrainz.config.query_interval - time_passed)
          end

          response = super
          @last_query_time = Time.now.to_f

          break if response.status == 200
        end

        response.body rescue nil
      end
    end
  end
end
