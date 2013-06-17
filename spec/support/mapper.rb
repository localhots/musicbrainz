def stub_run(body)
  MusicBrainz::Mapper::Generator::Base.stub(:schema).and_return(
    Nokogiri.parse(resource_input(body))
  )
  File.stub(:open).and_return{ @my_file = StringIO.new }
  MusicBrainz::Mapper::Generator::Base.run
end

def resource_output(body)
  %Q{
    module MusicBrainz
      module Mapper
        module Resources
          module Resource
            def self.included(base)
              base.send(:include, ::MusicBrainz::Mapper::Entity)
              
              base.class_eval do
                #{body}
              end
            end
          end
        end
      end
    end
  }
end

def strip_text(text, remove_empty_lines = true)
  text = text.strip.split("\n").map(&:strip)
  
  text.delete_if{|line| line == '' } if remove_empty_lines
  
  text.join("\n")
end

private

def resource_input(body, options = {})
  options = { name: 'resource' }.merge(options)
  %Q{<schema><#{options[:name]}>#{body}</#{options[:name]}></schema>}
end