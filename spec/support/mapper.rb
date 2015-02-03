class FileMock
  attr_accessor :closed, :string

  def initialize
    self.closed = false
    self.string = ''
  end
  
  def puts(value)
    if closed
      self.string = ''
      self.closed = false  
    end
    
    self.string += value + "\n"
  end
  
  def close
    self.closed = true
  end
end

def stub_run(body)
  allow(MusicBrainz::Mapper::Generator::Base).to receive(:schema).and_return(
    Nokogiri.parse(resource_input(body))
  )
  allow(File).to receive(:open).and_return(@my_file = FileMock.new)
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