# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Client do
  describe '#find' do
    it 'instantiates the resource properly' do
      mbid = 'bcf7c1d6-8cb5-41ca-a798-cb6e994f1bda'
          
      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents).with(
        "http://musicbrainz.org/ws/2/recording/#{mbid}?inc=url-rels"
      ).and_return(status: 200, body: "<metadata><recording id='#{mbid}'/></metadata>")
      
      recording = MusicBrainz::Client.new.find('MusicBrainz::Recording', mbid, [:url_rels])
      
      expect(recording.is_a?(MusicBrainz::Recording)).to be_truthy
      expect(recording.id).to be == mbid
    end  
  end
  
  describe '#search' do
    before :each do
      @expected = { id: 'bcf7c1d6-8cb5-41ca-a798-cb6e994f1bda', artist_name: 'Kasabian', title: 'Empire' }
      
      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents).with(
        %Q{http://musicbrainz.org/ws/2/recording?limit=10&query=artist:"#{@expected[:artist_name]}" AND recording:"#{@expected[:title]}"}
      ).and_return(
        status: 200, body: %Q{
          <metadata><recording-list count="35777" offset="0"><recording id="#{@expected[:id]}" ext:score="100"/></recording-list></metadata>
        }
      )  
    end
    
    it 'delegates it to the client properly' do
      recordings = MusicBrainz::Client.new.search('MusicBrainz::Recording', %Q{artist:"#{@expected[:artist_name]}" AND recording:"#{@expected[:title]}"})
      
      expect(recordings.length).to be == 1
      expect(recordings.first.id).to be == @expected[:id]
      expect(recordings.first.score).to be == 100
    end
    
    describe 'options' do
      describe 'create_models' do
        context 'true (default)' do
          it 'instantiates models' do
            recordings = MusicBrainz::Client.new.search('MusicBrainz::Recording', %Q{artist:"#{@expected[:artist_name]}" AND recording:"#{@expected[:title]}"})
      
            expect(recordings.length).to be == 1
            expect(recordings.first.id).to be == @expected[:id]
            expect(recordings.first.score).to be == 100
          end
        end
        
        context 'true (default)' do
          it 'returns an array a of hashes' do
            recordings = MusicBrainz::Client.new.search(
              'MusicBrainz::Recording', %Q{artist:"#{@expected[:artist_name]}" AND recording:"#{@expected[:title]}"}, create_models: false
            )
      
            expect(recordings).to be == [{score: 100, id: @expected[:id]}]
          end
        end
      end
    end
  end
end