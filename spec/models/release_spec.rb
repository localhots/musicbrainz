# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Release do
  describe '.find' do
    it 'delegates it to the client properly' do
      mbid = 'bcf7c1d6-8cb5-41ca-a798-cb6e994f1bda'
      
      MusicBrainz::Client.any_instance.should_receive(:find).with('MusicBrainz::Release', mbid, [:media, :release_groups, :url_rels])
      
      MusicBrainz::Release.find(mbid)
    end  
  end
  
  describe '.find_by_release_group_id' do
    it 'gets the releases for the release group with the given mbid' do
      MusicBrainz::ReleaseGroup.any_instance.should_receive(:releases).once
      
      described_class.find_by_release_group_id('6f33e0f0-cde2-38f9-9aee-2c60af8d1a61')
    end
  end
  
  describe '#tracks' do
    context 'tracks already set' do
      it 'returns the cached tracks' do
        release = MusicBrainz::Release.new(id: '2225dd4c-ae9a-403b-8ea0-9e05014c778f')
        release.tracks = [MusicBrainz::Track.new]
        
        MusicBrainz::Release.any_instance.should_not_receive(:association)
        
        release.tracks
      end 
    end
    
    context 'tracks not set yet' do
      it 'queries tracks' do
        MusicBrainz::Release.any_instance.should_receive(:association).with(:tracks, [:recordings, :media], :position)
        
        MusicBrainz::Release.new(id: '2225dd4c-ae9a-403b-8ea0-9e05014c778f').tracks
      end
    end
  end
end
