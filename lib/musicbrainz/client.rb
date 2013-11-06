# -*- encoding : utf-8 -*-
module MusicBrainz
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

      return nil if response[:status] != 200

      xml = Nokogiri::XML.parse(response[:body]).remove_namespaces!.xpath('/metadata')
      data = binding_class_for(params[:binding]).parse(xml)

      if params[:create_model]
        model_class_for(params[:create_model]).new(data)
      elsif params[:create_models]
        models = data.map{ |item| model_class_for(params[:create_models]).new(item) }
        models.sort!{ |a, b| a.send(params[:sort]) <=> b.send(params[:sort]) } if params[:sort]
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
