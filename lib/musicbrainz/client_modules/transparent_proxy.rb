# -*- encoding : utf-8 -*-
module MusicBrainz
  module ClientModules
    module TransparentProxy
      def get_contents(url)
        response = http.get(url)
        { body: response.body, status: response.status }
      rescue Faraday::Error::ClientError
        { body: nil, status: 500 }
      end
    end
  end
end
