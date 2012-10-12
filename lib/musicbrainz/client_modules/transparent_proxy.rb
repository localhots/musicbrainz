module MusicBrainz
  module ClientModules
    module TransparentProxy
      def get_contents(url)
        http.get url
      end
    end
  end
end
