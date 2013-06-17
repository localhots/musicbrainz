require 'spec_helper'

describe MusicBrainz::Mapper::List do
  describe 'standard, custom list and search result item attributes' do
    it 'works' do
      attributes = {
        total_count: 702, offset: 1, # def_list-attributes
        track_count: 3 # def_medium-list
      }
      
      # search result item score and item name
      artists = [[100, 'Fred'], [70, 'Fred de Fred']]

      # artist-list with relation-list and medium-list attributes
      artists_list = described_class.from_xml(%Q{<artist-list count="#{attributes[:total_count]}" offset="#{attributes[:offset]}">
        <track-count>#{attributes[:track_count]}</track-count>
        <artist ext:score="#{artists.first.first}"><name>#{artists.first.last}</name></artist>
        <artist id="d7102b7e-5a12-41b0-9050-d5762d22e2cb" type="Person" ext:score="#{artists.last.first}"><name>#{artists.last.last}</name></artist>
      </artist-list>})
     
      artists_list.count.should == 2
      artists_list.total_count.should == attributes[:total_count]
      artists_list.offset.should == attributes[:offset]
      artists_list.map{|artist| [artist.score, artist.name]}.should == artists
    end
  end
  
  describe 'target type hash' do
    it 'works' do
      work = MusicBrainz::Work.from_xml(%Q{<work id="4f4bec23-3ad7-3935-bf55-2315ac48fe2e">
        %Q{<relation-list target-type="artist">
          <relation type="composer"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
          <relation type="lyricist"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
        </relation-list>
        <relation-list target-type="recording">
          <relation type="performance"><recording id="20a908d5-0708-4a2b-991e-3f8644b747c5"/></relation>
        </relation-list>}
      </work>})
      
      work.relations.count.should == 3
      work.relations.keys.should == ['artist', 'recording']
      work.relations['artist'].count.should == 2
      work.relations['recording'].count.should == 1
      work.relations['xyz'].count.should == 0
      
      relations_list = described_class.from_xml(%Q{<relation-list target-type="artist">
        <relation type="composer"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
        <relation type="lyricist"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
      </relation-list>
      <relation-list target-type="recording">
        <relation type="performance"><recording id="20a908d5-0708-4a2b-991e-3f8644b747c5"/></relation>
      </relation-list>})
      
      relations_list.count.should == 3
      relations_list.keys.should == ['artist', 'recording']
      relations_list['artist'].count.should == 2
      relations_list['recording'].count.should == 1
      relations_list['xyz'].count.should == 0
    end
  end
end