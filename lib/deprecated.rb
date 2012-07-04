# -*- encoding: utf-8 -*-
module MusicBrainz
  def self.query_interval=(sec)
    MusicBrainz::Tools::Proxy.query_interval = sec
    puts "WARNING! MusicBrainz.query_interval is deprecated. Use MusicBrainz::Tools::Proxy.query_interval"
  end

  def self.cache_path=(path)
    MusicBrainz::Tools::Cache.cache_path = path
    puts "WARNING! MusicBrainz.cache_path is deprecated. Use MusicBrainz::Tools::Cache.cache_path"
  end
end
