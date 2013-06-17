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

        dir_path, file_path = nil, nil

        if MusicBrainz.config.hexdigest_url
          hash = Digest::SHA256.hexdigest(url)
          dir_path = [cache_path, *(0..2).map{ |i| hash.slice(2*i, 2) }].join(?/)
          file_path = [dir_path, '/', hash.slice(6, 58), '.xml'].join
        else
          # Don't use in production to avoid exploits
          url_parts = url.split(MusicBrainz.config.web_service_url)[1].match(/^(.+)(\?|\/)(.+)$/)
          
          dir_path = ([cache_path] + url_parts[1].split('/')).join(?/)
          file_path = [dir_path, '/', url_parts[3], '.xml'].join
        end
        
        response = { body: nil, status: 500 }

        if File.exist?(file_path)
          file = File.open(file_path, 'rb')
          
          body = if MusicBrainz.config.hexdigest_url
            file.gets
          else
            file.read
          end
          
          file.close
          
          response = { body: body, status: 200 }
        else
          response = super
          if response[:status] == 200
            FileUtils.mkpath(dir_path)
            File.open(file_path, 'wb') do |f|
              body = if MusicBrainz.config.hexdigest_url
                response[:body]
              else
                Nokogiri.parse(response[:body]).to_xml(:indent => 2, :encoding => 'UTF-8')
              end
              
              f.puts(body)
              f.chmod(0755)
              f.close
            end
          end
        end

        response
      end

      def caching?
        MusicBrainz.config.perform_caching
      end
    end
  end
end
