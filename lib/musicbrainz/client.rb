module MusicBrainz

  class RateLimit < Exception ; end

  class Client
    include ClientModules::TransparentProxy
    include ClientModules::FailsafeProxy
    include ClientModules::CachingProxy

    def http
      @faraday ||= Faraday.new do |f|
        f.request :url_encoded            # form-encode POST params
        f.adapter Faraday.default_adapter # make requests with Net::HTTP
        f.use     MusicBrainz::Middleware # run requests with correct headers
      end
    end

    def load(resource, query, params)
      raise Exception.new("You need to run MusicBrainz.configure before querying") if MusicBrainz.config.nil?

      url = build_url(resource, query)
      response = get_contents(url)

      raise RateLimit if response[:status] == 503
      return nil if response[:status] != 200

      xml = Nokogiri::XML.parse(response[:body]).remove_namespaces!.xpath('/metadata')
      data = binding_class_for(params[:binding]).parse(xml)

      if params[:create_model]
        model_class_for(params[:create_model]).new(data)
      elsif params[:create_models]
        models = data.map{ |item| model_class_for(params[:create_models]).new(item) }
        params[:sort] = [params[:sort]] if params[:sort].try(:is_a?, Symbol)
        models.sort! do |a, b| 
          params[:sort].reverse_each.inject(true) { |m, s| m && a.send(s) <=> b.send(s) }
        end if params[:sort]
        models
      else
        data
      end
    end

  private

    def build_url(resource, params)
      "#{MusicBrainz.config.web_service_url}#{resource.to_s.gsub('_', '-')}" <<
      ((id = params.delete(:id)) ? "/#{id}?" : "?") <<
      params.map do |key, value|
        key = key.to_s.gsub('_', '-')
        value = if value.is_a?(Array)
          value.map{ |el| el.to_s.gsub('_', '-') }.join(?+)
        else
          value.to_s
        end
        [key, value].join(?=)
      end.join(?&)
    end

    def binding_class_for(key)
      MusicBrainz::Bindings.const_get(constantized(key))
    end

    def model_class_for(key)
      MusicBrainz.const_get(constantized(key))
    end

    def constantized(key)
      key.to_s.split(?_).map(&:capitalize).join.to_sym
    end
  end

  module ClientHelper
    def client
      @client ||= Client.new
    end
  end
  extend ClientHelper
end
