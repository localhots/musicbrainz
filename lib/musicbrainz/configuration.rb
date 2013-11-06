# -*- encoding : utf-8 -*-
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

    def valid?
      %w[ app_name app_version contact ].each do |param|
        unless instance_variable_defined?(:"@#{param}")
          raise Exception.new("Application identity parameter '#{param}' missing")
        end
      end
      unless tries_limit.nil? && query_interval.nil?
        raise Exception.new("'tries_limit' parameter must be 1 or greater") if tries_limit.to_i < 1
        raise Exception.new("'query_interval' parameter must be greater than zero") if query_interval.to_f < 0
      end
      if perform_caching
        raise Exception.new("'cache_path' parameter must be set") if cache_path.nil?
      end
      true
    end
  end

  module Configurable
    def configure
      raise Exception.new("Configuration block missing") unless block_given?
      yield @config ||= MusicBrainz::Configuration.new
      config.valid?
    end

    def config
      raise Exception.new("Configuration missing") unless instance_variable_defined?(:@config)
      @config
    end

    def apply_test_configuration!
      configure do |c|
        c.app_name = "gem musicbrainz (development mode)"
        c.app_version = MusicBrainz::VERSION
        c.contact = `git config user.email`.chomp
      end
    end
  end
  extend Configurable
end
