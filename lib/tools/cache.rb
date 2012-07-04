# -*- encoding: utf-8 -*-
module MusicBrainz
  module Tools
    class Cache
      @@cache_path = nil

      def self.cache_path=(path)
        @@cache_path = path
      end

      def self.cache_path
        @@cache_path
      end

      def self.clear_cache
        FileUtils.rm_r(@@cache_path) if @@cache_path && File.exist?(@@cache_path)
      end

      def self.cache_contents(url)
        response = nil
        url_parts = url.split('/')
        file_name = url_parts.pop
        directory = url_parts.pop
        file_path = @@cache_path ? "#{@@cache_path}/#{directory}/#{file_name}" : nil

        if file_path && File.exist?(file_path)
          response = File.open(file_path).gets
        else
          response = yield

          unless response.nil? or file_path.nil?
            FileUtils.mkdir_p file_path.split('/')[0..-2].join('/')
            file = File.new(file_path, 'w')
            file.puts(response.gets) # .force_encoding('UTF-8')
            file.chmod(0755)
            file.close
            response.rewind
          end
        end

        response
      end
    end
  end
end
