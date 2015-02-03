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
      </artist-list>}.gsub('ext:score', 'score'))
     
      expect(artists_list.count).to be == 2
      expect(artists_list.total_count).to be == attributes[:total_count]
      expect(artists_list.offset).to be == attributes[:offset]
      expect(artists_list.map{|artist| [artist.score, artist.name]}).to be == artists
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
      
      expect(work.relations.count).to be == 3
      expect(work.relations.keys).to be == ['artist', 'recording']
      expect(work.relations['artist'].count).to be == 2
      expect(work.relations['recording'].count).to be == 1
      expect(work.relations['xyz'].count).to be == 0
      
      relations_list = described_class.from_xml(%Q{<relation-list target-type="artist">
        <relation type="composer"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
        <relation type="lyricist"><artist id="e4d54dd5-9eae-49d8-9a53-b5cbff13a9e5"/></relation>
      </relation-list>
      <relation-list target-type="recording">
        <relation type="performance"><recording id="20a908d5-0708-4a2b-991e-3f8644b747c5"/></relation>
      </relation-list>})
      
      expect(relations_list.count).to be == 3
      expect(relations_list.keys).to be == ['artist', 'recording']
      expect(relations_list['artist'].count).to be == 2
      expect(relations_list['recording'].count).to be == 1
      expect(relations_list['xyz'].count).to be == 0
    end
  end
end