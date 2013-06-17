module MusicBrainz
  class BaseModel
    attr_accessor :do_not_search
    
    def self.find(id, standard_includes = nil)
      standard_includes = standard_includes || [:url_rels]
      working_includes = (standard_includes + (includes || [])).uniq; eval("#{to_s}.includes = []")
      
      client.find(to_s, id, working_includes)
    end

    def self.client
      MusicBrainz.client
    end
    
    def self.with(*list)
      eval("#{to_s}.includes ||= []")
      
      list = (list.is_a?(Array) && list.first.is_a?(Array) ? list.first : list).map(&:to_sym)
      
      working_includes = []
      
      if list == [:all]
        # add all includes except includes which need authentification
        working_includes += (eval("#{to_s}::INCLUDES").map(&:to_sym) - [:user_tags, :user_ratings])
      else
        working_includes += list
      end
      
      {
        :discids => { 
          'MusicBrainz::Label' => [:releases],
          'MusicBrainz::Artist' => [:releases],
          'MusicBrainz::ReleaseGroup' => [:releases],
        }, 
        :media => { 
          'MusicBrainz::Label' => [:releases],
          'MusicBrainz::Artist' => [:releases],
          'MusicBrainz::ReleaseGroup' => [:releases],
        }, 
        :puids => { 
          'MusicBrainz::Artist' => [:recordings],
          'MusicBrainz::Release' => [:recordings],
        }, 
        :isrcs => { 
          'MusicBrainz::Artist' => [:recordings],
          'MusicBrainz::Release' => [:recordings],
        }, 
        :artist_credits => { 
          'MusicBrainz::Label' => [:releases],
          'MusicBrainz::Artist' => [:releases, :release_groups, :recordings, :works], 
        }, 
        :various_artists => { 'MusicBrainz::Artist' => [:releases] }
      }.each do |subquery_include, setting|
        next unless working_includes.include?(subquery_include)
        
        dependent_includes = setting[to_s]
        
        next if dependent_includes.nil? || dependent_includes.none?
        
        missing_dependent_includes = dependent_includes.select{|include| !working_includes.include?(include) }
        
        next if missing_dependent_includes.none?
        
        if working_includes.include?(:all)
          # TODO: should never been hit cause we've already determined and added all includes above
          working_includes += missing_dependent_includes
        else  
          raise ArgumentError.new("You need to include #{missing_dependent_includes.inspect} if you want to include #{subquery_include.inspect}")
        end
      end
      
      working_includes.delete_if{|include| include == :all }
      
      unknown_includes = working_includes.select{|include| !eval("#{to_s}::INCLUDES").include?(include.to_s) }
      
      if unknown_includes.any?
        raise ArgumentError.new("No valid inc parameter(s) for current resource: #{unknown_includes.inspect}")
      end
      
      eval("#{to_s}.includes += working_includes; #{to_s}.includes.uniq!")
      
      self
    end
    
    def self.includes
      @@includes ||= []
      
      @@includes
    end
    
    def self.includes=(value)
      @@includes = value
    end
    
    def initialize(params = {})
      params = if ['Nokogiri::XML::Document', 'Nokogiri::XML::NodeSet', 'Nokogiri::XML::Element'].include?(params.class.name)
        bindings_class = self.class.name.split('::')
        eval([bindings_class[0], 'Bindings', bindings_class[1]].join('::')).parse(params)
      else
        params
      end
      
      params.each do |field, value|
        self.send(:"#{field}=", value)
      end
    end
    
    def association(name, includes, sort)
      value = self.class.find(id, includes)
      
      return value unless value
      
      value = value.instance_variable_get("@#{name}")
      
      value.sort!{ |a, b| a.send(sort) <=> b.send(sort) } if value.is_a?(Array)
      
      value
    end
    
    protected

    def client
      MusicBrainz.client
    end
  end
end
