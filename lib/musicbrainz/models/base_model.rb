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
          if val.nil? or val == ""
            val = "2030-12-31"
          elsif val.split("-").length == 1
            val << "-12-31"
          elsif val.split("-").length == 2
            val << "-31"
          end
          Date.new(*val.split(?-).map(&:to_i))
        else
          val
        end
      end
    end
  end
end
