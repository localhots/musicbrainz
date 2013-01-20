module MusicBrainz
  module ClientModules
    module FailsafeProxy
      def get_contents(url)
        return super unless failsafe?

        response = { body: nil, status: 500 }
        MusicBrainz.config.tries_limit.times do
          response = super
          break if response[:status] == 200
        end

        response
      end

      def time_passed
        Time.now.to_f - @last_query_time ||= 0.0
      end

      def time_to_wait
        MusicBrainz.config.query_interval - time_passed
      end

      def ready?
        time_passed > MusicBrainz.config.query_interval
      end

      def wait_util_ready!
        sleep(time_to_wait) unless ready?
        @last_query_time = Time.now.to_f
      end

      def failsafe?
        MusicBrainz.config.tries_limit > 1 && MusicBrainz.config.query_interval.to_f > 0
      end
    end
  end
end
