module MusicBrainz
  class Middleware < Faraday::Middleware
    def call(env)
      env[:request_headers]["User-Agent"] = MusicBrainz.config.user_agent_string
      env[:request_headers]["Via"] = "gem musicbrainz/#{VERSION} (#{GH_PAGE_URL})"

      @app.call(env)
    end
  end
end
