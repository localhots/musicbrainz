module MusicBrainz
  module BaseModel
    def self.included(klass)
      klass.send(:include, InstanceMethods)
      klass.send(:extend, ClassMethods)
    end

    module ClassMethods
      def field(name, type)
        self.class_exec do
          attr_reader name

          define_method("#{name}=") do |val|
            instance_variable_set("@#{name}", validate_type(val, type))
          end
        end
      end
    end

    module InstanceMethods
      def initialize(params = {})
        params.each do |field, value|
          self.send :"#{field}=", value
        end
      end

      def validate_type(val, type)
        if type == Integer
          val.to_i
        elsif type == Float
          val.to_f
        elsif type == String
          val.to_s
        elsif type == Time
          if val.nil? or val == ""
            val = "2030-12-31"
          elsif val.split("-").length == 1
            val << "-12-31"
          elsif val.split("-").length == 2
            val << "-31"
          end
          Time.utc(*val.split("-"))
        else
          val
        end
      end
    end
  end
end
