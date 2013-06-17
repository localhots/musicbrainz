require 'spec_helper'

module MusicBrainz::Mapper::MyEntity
  def self.included(base)
    base.send(:include, ::MusicBrainz::Mapper::Entity)
      
    base.class_eval do   
      xml_accessor :sub_elements, from: 'sub-element-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true
      xml_accessor :array_elements, from: 'array-element-list/array-element', as: []
    end
  end
end

module MusicBrainz::Mapper::SubElement
  def self.included(base)
    base.send(:include, ::MusicBrainz::Mapper::Entity)
      
    base.class_eval do
      xml_accessor :name, from: 'name'
    end
  end
end

class MusicBrainz::MyEntity < MusicBrainz::BaseModel; include MusicBrainz::Mapper::MyEntity; end
class MusicBrainz::SubElement < MusicBrainz::BaseModel; include MusicBrainz::Mapper::SubElement; end

describe MusicBrainz::Mapper::Entity do
  describe '#to_primitive' do
    context 'list mapper attributes' do
      it 'returns primitive for each list element and adds a counter attribute' do
        my_entity = MusicBrainz::MyEntity.from_xml(
          %Q{
            <my-entity><sub-element-list count="1"><sub-element><name>Dummy</name></sub-element></sub-element-list></my-entity>  
          }
        ).to_primitive
  
        my_entity[:sub_elements].first[:name].should == 'Dummy'
        my_entity[:sub_elements_count].should == 1
      end
    end
    
    context 'array attributes' do
      it 'returns list elements as they are' do
        my_entity = MusicBrainz::MyEntity.from_xml(
          %Q{
            <my-entity><array-element-list><array-element>Dummy</array-element></array-element-list></my-entity>  
          }
        ).to_primitive
  
        my_entity[:array_elements].first.should == 'Dummy'
      end
    end
  end
end