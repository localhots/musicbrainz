# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::ReleaseGroup do
  describe '.search' do
    context 'without type filter' do
      context 'search by artist name and title' do
        it 'delegates to client properly' do
          expected = { artist_name: 'Kasabian', title: 'Empire' }
          
          expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(
            described_class.to_s, { query: %Q{artistname:"#{expected[:artist_name]}" AND releasegroup:"#{expected[:title]}*" } }, create_models: false
          )
          
          described_class.search(expected[:artist_name], expected[:title])
        end
      end
      
      context 'search by MusicBrainz ID of artist and title' do
        it 'delegates to client properly' do
          expected = { mbid: '69b39eab-6577-46a4-a9f5-817839092033', title: 'Empire' }
          
          expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(
            described_class.to_s, { query: %Q{arid:#{expected[:mbid]} AND releasegroup:"#{expected[:title]}*" } }, create_models: false
          )
          
          described_class.search(expected[:mbid], expected[:title])
        end
      end
    end
    
    context 'with type filter' do
      it "searches album release group by artist name and title" do
        expected = { artist_name: 'Kasabian', title: 'Empire', type: 'Album' }
        
        expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(
          described_class.to_s, { query: %Q{artistname:"#{expected[:artist_name]}" AND releasegroup:"#{expected[:title]}*"  AND type:#{expected[:type]}} }, 
          create_models: false
        )
        
        described_class.search(expected[:artist_name], expected[:title], type: expected[:type])
      end
    end
  end
  
  describe '.find_by_artist_and_title' do
    it "gets first release group by artist name and title" do
      expected = { artist_name: 'Kasabian', title: 'Empire', id: 'xyz' }
      
      allow(MusicBrainz::ReleaseGroup).to receive(:search).with(expected[:artist_name], expected[:title], {}).and_return([{ id: expected[:id] }])
      expect(MusicBrainz::ReleaseGroup).to receive(:find).with(expected[:id])
      
      described_class.find_by_artist_and_title(expected[:artist_name], expected[:title])
    end
  end
  
  describe '.find_by_artist_id' do
    it 'gets the release groups for the artist with the given mbid' do
      expect_any_instance_of(MusicBrainz::Artist).to receive(:release_groups).once
      described_class.find_by_artist_id('69b39eab-6577-46a4-a9f5-817839092033')
    end
  end
  
  describe '#releases' do
    context 'releases already set' do
      it 'returns the cached releases' do
        release_group = described_class.new(id: '2225dd4c-ae9a-403b-8ea0-9e05014c778f')
        release_group.releases = [MusicBrainz::Release.new]
        
        expect_any_instance_of(MusicBrainz::Client).not_to receive(:search)
        
        release_group.releases
      end 
    end
    
    context 'releases not set yet' do
      it 'queries releases' do
        id = '2225dd4c-ae9a-403b-8ea0-9e05014c778f'
        
        expect_any_instance_of(MusicBrainz::Client).to receive(:search).with(
          'MusicBrainz::Release', { release_group: id, inc: [:media, :release_groups, :recordings], limit: 100 }, sort: :date
        )
        
        described_class.new(id: id).releases
      end
    end
  end
end
