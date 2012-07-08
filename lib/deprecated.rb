# -*- encoding: utf-8 -*-

module MusicBrainz
  class << self
    def query_interval
      $stdout.send :puts, "WARNING! MusicBrainz.query_interval is deprecated. Use MusicBrainz::Tools::Proxy.query_interval"
      MusicBrainz::Tools::Proxy.query_interval
    end

    def query_interval=(sec)
      $stdout.send :puts, "WARNING! MusicBrainz.query_interval= is deprecated. Use MusicBrainz::Tools::Proxy.query_interval"
      MusicBrainz::Tools::Proxy.query_interval = sec
    end

    def cache_path
      $stdout.send :puts, "WARNING! MusicBrainz.cache_path is deprecated. Use MusicBrainz::Tools::Cache.cache_path"
      MusicBrainz::Tools::Cache.cache_path
    end

    def cache_path=(path)
      $stdout.send :puts, "WARNING! MusicBrainz.cache_path= is deprecated. Use MusicBrainz::Tools::Cache.cache_path"
      MusicBrainz::Tools::Cache.cache_path = path
    end
  end
end
