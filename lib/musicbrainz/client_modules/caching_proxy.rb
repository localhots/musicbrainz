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
        return super unless caching?

        hash = Digest::SHA256.hexdigest(url)
        dir_path = [cache_path, *(0..2).map{ |i| hash.slice(2*i, 2) }].join(?/)
        file_path = [dir_path, '/', hash.slice(6, 58), '.xml'].join

        response = { body: nil, status: 500 }

        if File.exist?(file_path)
          get_cached_contents(file_path)
        else
          response = get_live_contents(file_path, url)
          if response[:status] == 200
            cache_contents!(file_path, response[:body])
          end
          response
        end
      end

      def caching?
        MusicBrainz.config.perform_caching
      end

    private

      def get_cached_contents(file_path)
        {
          body: File.open(file_path, 'rb').gets,
          status: 200
        }
      end

      def get_live_contents(file_path, url)
        http.get(url)
      end

      def cache_contents!(file_path, body)
        dir_path = File.dirname(file_path)
        FileUtils.mkpath(dir_path)
        File.open(file_path, 'wb') do |f|
          f.puts(body)
          f.chmod(0755)
          f.close
        end
      end
    end
  end
end
