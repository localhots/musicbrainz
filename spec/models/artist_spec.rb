# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Artist do
  describe '.search' do
    it 'delegates to client properly' do
      artist_name = 'Kasabian'
      
      expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(described_class.to_s, "\"#{artist_name}\"", create_models: false)
      
      described_class.search(artist_name)
    end
  end
  
  describe '.find_by_name' do
    it "delegates to search properly" do
      expected = { name: 'Kasabian', id: '69b39eab-6577-46a4-a9f5-817839092033' }
      
      allow(described_class).to receive(:search).with(expected[:name]).and_return([expected])
      allow(described_class).to receive(:find).with(expected[:id]).and_return(described_class.new(id: expected[:id]))
      got = described_class.find_by_name(expected[:name])
      
      expect(got.id).to be == expected[:id]
    end
  end
  
  describe '#release_groups' do
    context 'release roups already set' do
      it 'returns the cached release groups' do
        artist = described_class.new(id: '2225dd4c-ae9a-403b-8ea0-9e05014c778f')
        artist.release_groups = [MusicBrainz::ReleaseGroup.new]
        
        expect_any_instance_of(MusicBrainz::Client).not_to receive(:search)
        
        artist.release_groups
      end 
    end
    
    context 'release groups not set yet' do
      it 'queries release groups' do
        id = '2225dd4c-ae9a-403b-8ea0-9e05014c778f'
        
        expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(
          'MusicBrainz::ReleaseGroup', { artist: id, inc: [:url_rels, :artist_credits], limit: 100, offset: 100 }, sort: :first_release_date
        )
        
        described_class.new(id: id).release_groups(offset: 100)
      end
    end
  end
end
