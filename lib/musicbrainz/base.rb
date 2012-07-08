# -*- encoding: utf-8 -*-

module MusicBrainz
  class Base
    class << self
      def field(name, type)
        @fields ||= {}
        @fields[name] = type

        define_method(name) {
          instance_variable_get("@#{name}")
        }
        define_method("#{name}=") { |val|
          instance_variable_set("@#{name}", validate_type(val, type))
        }
      end

      def load(params, query)
        parser = MusicBrainz::Parsers.get_by_name(params[:parser])
        xml = MusicBrainz::Tools::Proxy.query(query)
        result = parser[:const].send(parser[:method], Nokogiri::XML(xml))
        if params[:create_model]
          result_model = params[:create_model].new
          result.each { |field, value|
            result_model.send("#{field}=".to_sym, value)
          }
          result_model
        elsif params[:create_models]
          result_models = []
          result.each { |item|
            result_model = params[:create_models].new
            item.each { |field, value|
              result_model.send("#{field}=".to_sym, value)
            }
            result_models << result_model
          }
          result_models
        else
          result
        end
      end
    end

    def initialize
      self.class.instance_variable_get("@fields").each { |name, type|
        instance_variable_set("@#{name}", nil)
      }
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
