module MusicBrainz
  module Deprecated
    module ProxyConfig
      def query_interval
        MusicBrainz.config.query_interval
      end

      def query_interval=(value)
        MusicBrainz.config.query_interval = value
      end
    end

    module CacheConfig
      def cache_path
        MusicBrainz.config.cache_path
      end

      def cache_path=(value)
        MusicBrainz.config.cache_path = value
      end
    end
  end

  module Tools
    module Proxy
      extend Deprecated::ProxyConfig
    end

    module Cache
      extend Deprecated::CacheConfig
    end
  end

  extend Deprecated::ProxyConfig
  extend Deprecated::CacheConfig
end
