# -*- encoding: utf-8 -*-

require 'spec_helper'

describe MusicBrainz::Recording do
  describe '.search' do
    context 'track released on an any release group type' do
      it 'delegates to client properly' do
        expected = { artist_name: 'Kasabian', title: 'Empire' }
      
        MusicBrainz::Client.any_instance.should_receive(:search).with(
          described_class.to_s, %Q{artist:"#{expected[:artist_name]}" AND recording:"#{expected[:title]}"}, create_models: false
        )
        
        described_class.search(expected[:artist_name], expected[:title])
      end
    end
    
    context 'only track released on an album' do
      it 'searches track by artist name and title' do
        expected = { artist_name: 'Kasabian', title: 'Empire', type: 'Album' }
      
        MusicBrainz::Client.any_instance.should_receive(:search).with(
          described_class.to_s, %Q{artist:"#{expected[:artist_name]}" AND recording:"#{expected[:title]}" AND type: #{expected[:type]}}, create_models: false
        )
        
        described_class.search(expected[:artist_name], expected[:title], type: expected[:type])
      end
    end
  end
  
  describe '.find_by_artist_and_title' do
    it 'gets first release group by artist name and title' do
      expected = { artist_name: 'Kasabian', title: 'Empire', id: 'xyz' }
      
      MusicBrainz::Recording.should_receive(:search).with(expected[:artist_name], expected[:title], {}).and_return([{ id: expected[:id] }])
      MusicBrainz::Recording.should_receive(:find).with(expected[:id])
      
      described_class.find_by_artist_and_title(expected[:artist_name], expected[:title])
    end
  end
end