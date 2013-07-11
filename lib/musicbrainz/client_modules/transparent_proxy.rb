module MusicBrainz
  module ClientModules
    module TransparentProxy
      def get_contents(url)
        response = http.get(url)
        { body: response.body, status: response.status }
      end
    end
  end
end
