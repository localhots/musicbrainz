# -*- encoding: utf-8 -*-

module MusicBrainz

  def self.configure
    yield @config ||= MusicBrainz::Tools::Configuration.new
  end

  def self.config
    @config
  end

  module Tools
    class Configuration
      def self.add_config name, value=nil
        self.instance_variable_set "@#{name}", value

        class_eval <<-RUBY
          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            @#{name} || self.class.instance_variable_get('@#{name}')
          end
        RUBY
      end

      DEFAULT_USER_AGENT = "gem musicbrainz (https://github.com/magnolia-fan/musicbrainz) @ " + Socket.gethostname

      add_config :application
      add_config :version
      add_config :contact

      add_config :query_interval, 1.5
      add_config :tries_limit, 5

      add_config :web_service_url, "http://musicbrainz.org/ws/2/"

      def user_agent
        return @user_agent if @user_agent

        if application
          @user_agent = application
          @user_agent << "/#{version}" if version
          @user_agent << " (#{contact})" if contact
          @user_agent << ' via '
        end

        @user_agent = "#{@user_agent}#{DEFAULT_USER_AGENT}"
      end
    end
  end
end
