module MusicBrainz
  def query_interval
    MusicBrainz.config.query_interval
  end

  def query_interval=(value)
    MusicBrainz.config.query_interval = value
  end

  def cache_path
    MusicBrainz.config.cache_path
  end

  def cache_path=(value)
    MusicBrainz.config.cache_path = value
  end

  module Tools
    module Proxy
      def query_interval
        MusicBrainz.config.query_interval
      end

      def query_interval=(value)
        MusicBrainz.config.query_interval = value
      end

      extend self
    end

    module Cache
      def cache_path
        MusicBrainz.config.cache_path
      end

      def cache_path=(value)
        MusicBrainz.config.cache_path = value
      end

      extend self
    end
  end

  extend self
end
