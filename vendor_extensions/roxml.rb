# https://github.com/Applicat/roxml/compare/master...voluntary_music_research
module ROXML # :nodoc:
  module InstanceMethods # :nodoc:
    def initialize(*arguments)
      attributes = arguments.first.is_a?(Hash) ? arguments.first : {}
      
      attributes.each {|name, value| send("#{name}=", value) }
      
      super()
    end
  end
  
  class Definition # :nodoc:
    bool_attr_reader :name_explicit, :array, :cdata, :required, :frozen, :sought_type_argument_is_a_nodeset
    
    def initialize(sym, opts = {}, &block)
      opts.assert_valid_keys(:from, :in, :as, :namespace,
                             :else, :required, :frozen, :cdata, :to_xml, :sought_type_argument_is_a_nodeset)
      @default = opts.delete(:else)
      @to_xml = opts.delete(:to_xml)
      @name_explicit = opts.has_key?(:from) && opts[:from].is_a?(String)
      @cdata = opts.delete(:cdata)
      @required = opts.delete(:required)
      @frozen = opts.delete(:frozen)
      @wrapper = opts.delete(:in)
      @namespace = opts.delete(:namespace)
      @sought_type_argument_is_a_nodeset = opts.delete(:sought_type_argument_is_a_nodeset)

      @accessor = sym.to_s
      opts[:as] ||=
        if @accessor.ends_with?('?')
          :bool
        elsif @accessor.ends_with?('_on')
          Date
        elsif @accessor.ends_with?('_at')
          DateTime
        end

      @array = opts[:as].is_a?(Array)
      @blocks = collect_blocks(block, opts[:as])

      @sought_type = extract_type(opts[:as])
      if @sought_type.respond_to?(:roxml_tag_name)
        opts[:from] ||= @sought_type.roxml_tag_name
      end

      if opts[:from] == :content
        opts[:from] = '.'
      elsif opts[:from] == :name
        opts[:from] = '*'
      elsif opts[:from] == :attr
        @sought_type = :attr
        opts[:from] = nil
      elsif opts[:from] == :namespace
        opts[:from] = '*'
        @sought_type = :namespace
      elsif opts[:from].to_s.starts_with?('@')
        @sought_type = :attr
        opts[:from].sub!('@', '')
      end

      @name = @attr_name = accessor.to_s.chomp('?')
      @name = @name.singularize if hash? || array?
      @name = (opts[:from] || @name).to_s
      if hash? && (hash.key.name? || hash.value.name?)
        @name = '*'
      end
      raise ContradictoryNamespaces if @name.include?(':') && (@namespace.present? || @namespace == false)

      raise ArgumentError, "Can't specify both :else default and :required" if required? && @default
    end
  end
  
  class XMLRef # :nodoc:
    private
    
    def nodes_in(xml)
      @default_namespace = XML.default_namespace(xml)
      vals = XML.search(xml, xpath, @instance.class.roxml_namespaces)

      if several? && vals.empty? && !wrapper && auto_xpath
        vals = XML.search(xml, auto_xpath, @instance.class.roxml_namespaces)
        @auto_vals = !vals.empty?
      end

      if vals.empty?
        raise RequiredElementMissing, "#{name} from #{xml} for #{accessor}" if required?
        default
      elsif several?
        vals.map do |val|
          yield val
        end
      elsif opts.sought_type_argument_is_a_nodeset?
        yield(vals)
      else
        yield(vals.first)
      end
    end
  end
end