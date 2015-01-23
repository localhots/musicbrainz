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

    def find(resource, id, includes = [])
      raise Exception.new("You need to run MusicBrainz.configure before querying") if MusicBrainz.config.nil?

      params = { id: id }
      params[:inc] = includes unless includes.empty?
      
      response = get_contents(build_url(resource, params))
      
      if response[:status] == 200
        MusicBrainz.const_get(resource.split('::').pop.to_sym).from_xml(
          Nokogiri::XML.parse(response[:body]).remove_namespaces!.xpath('/metadata/*[1]').to_xml
        )
      else
        nil
      end
    end
    
    def search(resource, params, options = {})
      raise Exception.new("You need to run MusicBrainz.configure before querying") if MusicBrainz.config.nil?
      
      params = { query: params } if params.is_a?(String)
      params = { limit: 10 }.merge(params)
      response = get_contents(build_url(resource, params))

      return nil unless response[:status] == 200

      models = MusicBrainz::Mapper::List.from_xml(
        Nokogiri::XML.parse(response[:body]).remove_namespaces!.xpath('/metadata/*').to_xml
      )
      
      options = { create_models: true }.merge(options) 
      
      if options[:create_models]
        models.sort!{ |a, b| a.send(options[:sort]) && b.send(options[:sort]) ? a.send(options[:sort]) <=> b.send(options[:sort]) : a.send(options[:sort]) ? 1 : - 1} if options[:sort]
        models
      else
        models.to_primitive
      end
    end

  private

    def build_url(resource, params)
      resource = resource == 'MusicBrainz::Track' ? 'MusicBrainz::Recording' : resource
      resource = underscore(resource.split('::').last)
      
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
    
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/(?:([A-Za-z\d])|^)((?=a)b)(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end

  module ClientHelper
    def client
      @client ||= Client.new
    end
  end
  extend ClientHelper
end
