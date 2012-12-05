module MusicBrainz
  module Client
    def http
      @faraday ||= Faraday.new do |f|
        f.request :url_encoded            # form-encode POST params
        f.adapter Faraday.default_adapter # make requests with Net::HTTP
        f.use     MusicBrainz::Middleware # run requests with correct headers
      end
    end

    def load(resource, query, params)
      raise Exception.new("You need to run MusicBrainz.configure before querying") if MusicBrainz.config.nil?

      response = contents_of(build_url(resource, query))
      xml = Nokogiri::XML.parse(response).remove_namespaces!.xpath('/metadata')
      data = params[:binding].parse(xml)

      if params[:create_model]
        params[:create_model].new(data)
      elsif params[:create_models]
        models = data.map{ |item| params[:create_models].new(item) }
        models.sort!{ |a, b| a.send(params[:sort]) <=> b.send(params[:sort]) } if params[:sort]
        models
      else
        data
      end
    end

    def contents_of(url)
      if method_defined? :get_contents
        get_contents url
      else
        http.get url
      end
    end

    def build_url(resource, params)
      "#{MusicBrainz.config.web_service_url}#{resource.to_s.gsub('_', '-')}" <<
      ((id = params.delete(:id)) ? "/#{id}?" : "?") <<
      params.map do |key, value|
        key = key.to_s.gsub('_', '-')
        value = if value.is_a?(Array)
          value.map{ |el| el.to_s.gsub('_', '-') }.join('+')
        else
          value.to_s
        end
        "#{key}=#{value}"
      end.join('&')
    end

    include ClientModules::TransparentProxy
    include ClientModules::FailsafeProxy
    include ClientModules::CachingProxy
    extend self
  end
end
