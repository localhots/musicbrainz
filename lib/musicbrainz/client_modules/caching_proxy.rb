module MusicBrainz
  module ClientModules
    module CachingProxy
      def cache_path
        MusicBrainz.config.cache_path
      end

      def clear_cache
        FileUtils.rm_r(cache_path) if cache_path && File.exist?(cache_path)
      end

      def get_contents(url)
        return super unless MusicBrainz.config.perform_caching

        token = Digest::SHA256.hexdigest(url)
        file_path = "#{cache_path}/#{token[0..1]}/#{token[2..3]}/#{token[4..-1]}.xml"

        response = nil

        if File.exist?(file_path)
          response = File.open(file_path, 'rb').gets
        else
          response = super
          unless response.nil? or response.empty?
            FileUtils.mkdir_p file_path.split('/')[0..-2].join('/')
            File.open(file_path, 'wb') do |f|
              f.puts response
              f.chmod 0755
              f.close
            end
          end
        end

        response
      end
    end
  end
end
