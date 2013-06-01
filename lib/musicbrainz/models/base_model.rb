module MusicBrainz
  class BaseModel
    def self.inherited(klass)
      klass.send(:include, InstanceMethods)
      klass.send(:extend, ClassMethods)
    end

    module ClassMethods
      def field(name, type)
        fields[name] = type
        attr_reader name

        define_method("#{name}=") do |val|
          instance_variable_set("@#{name}", validate_type(val, type))
        end
      end

      def fields
        instance_variable_set(:@fields, {}) unless instance_variable_defined?(:@fields)
        instance_variable_get(:@fields)
      end

      def client
        MusicBrainz.client
      end

			def search(hash, resource=nil)
				hash = escape_strings(hash)
				query_val = build_query(hash)
				underscore_name = self.name[13..-1].underscore
				if resource # only needed since "track" is really a "recording", ugly
					client.load(resource, { query: query_val, limit: 10 }, { binding: underscore_name.insert(-1,"_search").to_sym })
				else
					client.load(underscore_name.to_sym, { query: query_val, limit: 10 }, { binding: underscore_name.insert(-1,"_search").to_sym })
				end
			end

			class ::String
				def underscore
					self.gsub(/::/, '/').
					gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
					gsub(/([a-z\d])([A-Z])/,'\1_\2').
					tr("-", "_").
					downcase
				end
			end

			def build_query(hash)
				return ["#{hash.first[0].to_s}:\"#{hash.first[1]}\""] if hash.size ==1
				arr ||= []
				hash.each { |k, v| arr << "#{k.to_s}:\"#{hash[k]}\"" }
				arr.join(' AND ')
			end

			def escape_strings(hash)
				hash.each { |k, v| hash[k] = CGI.escape(v).gsub(/\!/, '\!') }
				hash
			end

			# these probably should be private... but I'm not sure how to get it to work in a module...
			# private_class_method :build_query, :escape_strings
    end

    module InstanceMethods
      def initialize(params = {})
        params.each do |field, value|
          self.send(:"#{field}=", value)
        end
      end

      def client
        MusicBrainz.client
      end

    private

      def validate_type(val, type)
        if type == Integer
          val.to_i
        elsif type == Float
          val.to_f
        elsif type == String
          val.to_s
        elsif type == Date
          val = if val.nil? or val == ""
            [2030, 12, 31]
          elsif val.split("-").length == 1
            [val.split("-").first.to_i, 12, 31]
          elsif val.split("-").length == 2
            val = val.split("-").map(&:to_i)
            [val.first, val.last, -1]
          else
            val.split("-").map(&:to_i)
          end
          
          Date.new(*val)
        else
          val
        end
      end
    end
  end
end
