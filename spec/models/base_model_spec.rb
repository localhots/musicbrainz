# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::BaseModel do
  describe '.find' do
    shared_examples 'BaseModel.find' do |subject_type|
      it 'delegates it to the client properly with standard includes' do
        mbid = 'bcf7c1d6-8cb5-41ca-a798-cb6e994f1bda'
        
        MusicBrainz::Client.any_instance.should_receive(:find).with(subject_type, mbid, [:url_rels])
        
        MusicBrainz.const_get(subject_type.split('::').pop.to_sym).find(mbid)
      end 
    end
    
    ['Label', 'Artist', 'ReleaseGroup', 'Work', 'Track', 'Recording'].each do |subject_type| 
      include_examples('BaseModel.find', "MusicBrainz::#{subject_type}") 
    end  
    
    context 'with includes' do
      it 'delegates it to the client properly with standard includes plus manual includes' do
        mbid = 'bcf7c1d6-8cb5-41ca-a798-cb6e994f1bda'
        
        MusicBrainz::Client.any_instance.should_receive(:find).with('MusicBrainz::Artist', mbid, [:url_rels, :tags])
        
        MusicBrainz::Artist.with(:tags).find(mbid)
      end 
    end
  end
  
  describe '.search' do
    it 'delegates it to the client properly' do
      expected = { artist_name: 'Kasabian', title: 'Empire' }
      
      MusicBrainz::Client.any_instance.should_receive(:search).with(
        'MusicBrainz::Recording', %Q{artist:"#{expected[:artist_name]}" AND recording:"#{expected[:title]}"}, create_models: false
      )
      
      MusicBrainz::Recording.search(expected[:artist_name], expected[:title])
    end  
  end
  
  describe '.with' do
    context 'all' do
      it 'determines all includes through the INCLUDE constant of the model' do
        MusicBrainz::Artist.with(:all)
        
        MusicBrainz::Artist.includes.should == MusicBrainz::Artist::INCLUDES.map(&:to_sym)
        
        MusicBrainz::Artist.includes = []
      end
    end

    describe 'care about dependent includes' do
      context 'missing dependent includes' do
        it 'raises an exception' do
          expect { MusicBrainz::Artist.with(:puids) }.to raise_error(
            ArgumentError, 'You need to include [:recordings] if you want to include :puids'
          )
        end
      end
      
      context 'no missing dependent includes' do
        it 'raises no exception' do
          expect { MusicBrainz::Artist.with([:puids, :recordings]) }.to_not raise_error
           
          MusicBrainz::Artist.includes = []
        end
      end
    end
    
    describe 'notify about unknown includes' do
      it 'raises an exception' do
        expect { MusicBrainz::Artist.with(:unknown) }.to raise_error(
          ArgumentError, 'No valid inc parameter(s) for current resource: [:unknown]'
        )
      end
    end
  end
  
  describe '#association' do
    it 'returns a sorted list' do
      expected = [{ position: 2 }, { position: 1 }].map{|attributes| MusicBrainz::Track.new(attributes)}
      
      MusicBrainz::Release.should_receive(:find).with('2225dd4c-ae9a-403b-8ea0-9e05014c778f', [:recordings, :media]).and_return(
        MusicBrainz::Release.new(tracks: expected)
      )
      
      got = MusicBrainz::Release.new(id: '2225dd4c-ae9a-403b-8ea0-9e05014c778f').tracks
       
      got.first.position.should == 1
      got.last.position.should == 2
    end
  end
end