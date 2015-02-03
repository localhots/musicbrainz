require 'spec_helper'

describe MusicBrainz::Mapper::Generator::Resource do
  describe 'basics for attributes and elements' do
    describe 'accessor name' do
      it 'returns it as symbol with underscores' do
        ['attributes', 'elements'].each do |type|
          stub_run("<#{type}><namespace-field><type><name>String</name></type></namespace-field></#{type}>")
          
          from_prefix = type == 'attributes' ? '@' : ''
          expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :namespace_field, from: '#{from_prefix}namespace-field'"))
        end
      end
    end
  end
  
  describe '#add_attribute' do
    describe 'from' do
      it 'returns @#{name}' do
        stub_run('<attributes><field><type><name>String</name></type></field></attributes>')
        
        expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :field, from: '@field'"))
      end
    end
  end
  
  describe '#add_element' do
    context 'without parent' do
      context 'without from' do
        it 'returns value from element name' do
          stub_run('<elements><field><type><name>String</name></type></field></elements>')
          
          expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :field, from: 'field'"))
        end
      end
      
      context 'with from' do
        it 'returns value from deviant from attribute' do
          stub_run('<elements><field><from>../resource</from><type><name>String</name></type></field></elements>')
          
          expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :field, from: '../resource'"))
        end
      end
      
      describe 'as' do
        context 'Integer' do
          it 'returns as integer' do
            stub_run('<elements><field><type><name>Integer</name></type></field></elements>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :field, from: 'field', as: Integer"))
          end
        end
        
        context 'IncompleteDate' do
          it 'returns as integer' do
            stub_run('<elements><field><type><name>IncompleteDate</name></type></field></elements>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(
              resource_output("xml_accessor(:field, from: 'field') {|date| MusicBrainz::Mapper::Entity.to_date(date) }")
            )
          end
        end
        
        context 'Boolean' do
          it 'returns block' do
            stub_run('<elements><field><type><name>Boolean</name></type></field></elements>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(
              resource_output("xml_accessor(:field, from: 'field') {|boolean| boolean.to_s.strip == 'true' ? true : false}")
            )
          end
        end
      end
      
      describe 'comment' do
        context 'with comment' do
          it 'renders a comment at the end' do
            stub_run('<elements><field><type><name>String</name><comment>Dummy</comment></type></field></elements>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :field, from: 'field' # Dummy"))
          end
        end
      end
    end
    
    context 'with parent' do
      context 'is_array' do
        context 'true through parent name matching list' do
          it 'returns element name pluralized through parent and sets as option to array' do
            stub_run('<elements><secondary-type><parent>secondary-type-list</parent><type><name>String</name></type></secondary-type></elements>')
            
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :secondary_types, from: 'secondary-type-list/secondary-type', as: []"))
          end
        end
        
        context 'false' do
          it 'returns element name as it is through parent and do not set as option' do
            stub_run('<elements><begin><parent>life-span</parent><type><name>IncompleteDate</name></type></begin></elements>')
            
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :begin, from: 'life-span/begin'"))
          end
        end
      end
    end
  end
  
  describe '#add_ref' do
    describe 'accessor name' do
      describe 'pluralization' do
        context 'ipi' do
          it 'returns ipis' do
            stub_run('<refs><ipi-list><resource><name>ipi</name><type><name>String</name></refs>')
            
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :ipis, from: 'ipi-list/ipi', as: []"))
          end
        end 
        
        context 'names' do
          it 'returns nameses' do
            stub_run('<refs><alias-list><resource><name>alias</name></resource></alias-list></refs>')
            
            expect(strip_text(@my_file.string)).to be == strip_text(
              resource_output("xml_accessor :aliases, from: 'alias-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true")
            )
          end
        end  
      end
      
      context '*-' do
        it 'replaces dashes by underscore' do
          stub_run('<refs><release-group/></refs>')
        
          expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :release_group, from: 'release-group', as: MusicBrainz::ReleaseGroup"))
        end
      end
    end
    
    describe 'as' do
      context '<ref_name/>' do
        it 'returns ComplexType' do
          # TODO: handle wrapping of standard list attributes through :as
          stub_run('<refs><annotation/></refs>')

          expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :annotation, from: 'annotation', as: MusicBrainz::Annotation"))
        end
      end
      
      context 'ref_name/resource' do
        context 'complex type' do
          it 'returns [ComplexType]' do
            # TODO: handle wrapping of standard list attributes through :as
            stub_run('<refs><release-group-list><resource><name>release-group</name></resource></release-group-list></refs>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(
              resource_output(
                "xml_accessor :release_groups, from: 'release-group-list', as: MusicBrainz::Mapper::List, sought_type_argument_is_a_nodeset: true"
              )
            )
          end
        end
        
        context 'primitive type' do
          it 'returns []' do
            # TODO: handle wrapping of standard list attributes through :as
            stub_run('<refs><ipi-list><resource><name>ipi</name><type><name>String</name></type></resource></ipi-list></refs>')
          
            expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :ipis, from: 'ipi-list/ipi', as: []"))
          end
        end
      end
    end
    
    context 'artist-credit' do
      it 'works' do
        stub_run(%Q{<refs>
          <artist-credit>
            <resource><parent>name-credit</parent><parent_attribute>joinphrase</parent_attribute><name>artist</name></resource>
          </artist-credit>
        </refs>})
        
        expect(strip_text(@my_file.string)).to be == strip_text(resource_output("xml_accessor :artists, from: 'artist-credit/name-credit/artist', as: [::MusicBrainz::NameCredit]"))
      end
    end
  end
end