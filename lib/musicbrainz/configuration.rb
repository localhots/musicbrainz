module MusicBrainz
  class Configuration
    attr_accessor :app_name, :app_version, :contact,
                  :web_service_url,
                  :query_interval, :tries_limit,
                  :cache_path, :perform_caching

    DEFAULT_WEB_SERVICE_URL = "http://musicbrainz.org/ws/2/"
    DEFAULT_QUERY_INTERVAL = 1.5
    DEFAULT_TRIES_LIMIT = 5
    DEFAULT_CACHE_PATH = File.join(File.dirname(__FILE__), "..", "tmp", "cache")
    DEFAULT_PERFORM_CACHING = false

    def initialize
      @web_service_url = DEFAULT_WEB_SERVICE_URL
      @query_interval = DEFAULT_QUERY_INTERVAL
      @tries_limit = DEFAULT_TRIES_LIMIT
      @cache_path = DEFAULT_CACHE_PATH
      @perform_caching = DEFAULT_PERFORM_CACHING
    end

    def user_agent_string
      %w[ app_name app_version contact ].each do |param|
        raise "#{param} must be set" if instance_variable_get("@#{param}").nil?
      end

      "#{@app_name}/#{@app_version} ( #{@contact} )"
    end
  end

  module Configurable
    def configure
      raise "Configuration missing" unless block_given?
      yield @config ||= MusicBrainz::Configuration.new
    end

    def config
      @config
    end
  end
  extend Configurable
end
