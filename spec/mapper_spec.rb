require 'spec_helper'

describe MusicBrainz::Mapper do
  describe '#add_attribute' do
    describe 'from' do
      it 'returns @#{name}' do
        value = '337e30b6-3dbe-44f2-a3fd-84a80abdb5a1'
        annotation_name = 'My Annotation'
        
        artist = MusicBrainz::Artist.from_xml(
          %Q{
            <artist id="#{value}">
              <annotation><name>#{annotation_name}</name></annotation>
            </artist>
          }
        )
        
        artist.id.should == value
        artist.annotation.name.should == annotation_name
      end
    end
  end
 
  describe '#add_element' do
    context 'without parent' do
      describe 'as' do
        context 'Integer' do
          it 'returns an integer' do
            class Entity
              include ROXML
              
              xml_accessor :field, from: 'field', as: Integer
            end
            
            entity = Entity.from_xml('<entity><field>1</field></entity>')
            
            entity.field.should == 1
            Object.send(:remove_const, :Entity)
          end
        end

        context 'IncompleteDate' do
          context 'nil value' do
            it 'returns 2030-12-31' do
              xml = '<release-group><first-release-date></first-release-date></release-group>'
              release_group = MusicBrainz::ReleaseGroup.from_xml(xml)
              release_group.first_release_date.should == Date.new(2030, 12, 31)
            end
          end

          context 'year only' do
            it 'returns 1995-12-31' do
              xml = '<release-group><first-release-date>1995</first-release-date></release-group>'
              release_group = MusicBrainz::ReleaseGroup.from_xml(xml)
              release_group.first_release_date.should == Date.new(1995, 12, 31)
            end
          end
  
          context 'year and month only' do
            it 'returns 1995-04-30' do
              xml = '<release-group><first-release-date>1995-04</first-release-date></release-group>'
              release_group = MusicBrainz::ReleaseGroup.from_xml(xml)
              release_group.first_release_date.should == Date.new(1995, 4, 30)
            end
          end
          
          context 'year, month and day' do
            it 'returns 1995-04-30' do
              xml = '<release-group><first-release-date>1995-04-30</first-release-date></release-group>'
              release_group = MusicBrainz::ReleaseGroup.from_xml(xml)
              release_group.first_release_date.should == Date.new(1995, 4, 30)
            end
          end
        end

        context 'Boolean' do
          it 'returns block' do
            ['true', 'false'].each do |value|
              class Entity
                include ROXML
                
                xml_accessor(:field, from: 'field') {|boolean| boolean.to_s.strip == 'true' ? true : false}
              end
              
              entity = Entity.from_xml("<entity><field>#{value}</field></entity>")
              
              entity.field.should == eval(value)
              Object.send(:remove_const, :Entity)
            end
          end
        end
      end
    end
    
    context 'with parent' do
      context 'is_array' do
        it 'returns name through parent' do
          types = ['Type 1', 'Type 2']
          
          MusicBrainz::ReleaseGroup.from_xml(
            %Q{<release-group>
              <secondary-type-list>
                <secondary-type>#{types.first}</secondary-type>
                <secondary-type>#{types.last}</secondary-type>
              </secondary-type-list>
            </artist>}
          ).secondary_types.should == types
        end
      end
    end
  end
  
  describe '#add_ref' do
    describe 'as' do
      context 'artist-credit' do
        it 'makes an exception' do
          expected = [['Eminem', ' feat. '], ['Rihanna', nil]]
          
          MusicBrainz::Recording.from_xml(
            %Q{<recording>
              <artist-credit>
                <name-credit joinphrase="#{expected[0][1]}"><artist><name>#{expected[0][0]}</name></artist></name-credit>
                <name-credit><artist><name>#{expected[1][0]}</name></artist></name-credit>
              </artist-credit>
            </recording>}
          ).artists.map{|artist| [artist.name, artist.joinphrase]}.should == expected
        end  
      end
      
      context 'complex type' do
        it 'returns [ComplexType]' do
          collection = ['1', '2']
          
          MusicBrainz::Artist.from_xml(
            %Q{<artist>
              <recording-list><recording id="#{collection[0]}"/><recording id="#{collection[1]}"/></recording-list>
            </artist>}
          ).recordings.map(&:id).should == collection
        end
      end
      
      context 'primitive type' do
        it 'returns []' do
          collection = ['1', '2']
          
          MusicBrainz::Artist.from_xml(
            %Q{<artist>
              <ipi-list><ipi>#{collection[0]}</ipi><ipi>#{collection[1]}</ipi></ipi-list>
            </artist>}
          ).ipis.should == collection
        end
      end
    end
  end
end