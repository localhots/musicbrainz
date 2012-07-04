require 'spec_helper'

describe MusicBrainz do
  
  describe '.cache_contents', :vcr do
    let(:cache_path) { File.join(File.dirname(__FILE__), '../../tmp/rspec_test/musicbrainz') }
    let(:response) { ::StringIO.new('<?xml version="1.0" encoding="UTF-8"?><metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#"><artist type="Group" id="69b39eab-6577-46a4-a9f5-817839092033"><name>Kasabian</name><sort-name>Kasabian</sort-name><country>GB</country><life-span><begin>1999</begin></life-span><relation-list target-type="url"><relation type="allmusic"><target>http://allmusic.com/artist/p678134</target></relation><relation type="wikipedia"><target>http://en.wikipedia.org/wiki/Kasabian</target></relation><relation type="microblog"><target>http://twitter.com/kasabianhq</target></relation><relation type="BBC Music page"><target>http://www.bbc.co.uk/music/artists/69b39eab-6577-46a4-a9f5-817839092033</target></relation><relation type="discogs"><target>http://www.discogs.com/artist/Kasabian</target></relation><relation type="social network"><target>http://www.facebook.com/kasabian</target></relation><relation type="IMDb"><target>http://www.imdb.com/name/nm1868442/</target></relation><relation type="official homepage"><target>http://www.kasabian.co.uk/</target></relation><relation type="myspace"><target>http://www.myspace.com/kasabian</target></relation><relation type="youtube"><target>http://www.youtube.com/kasabianvevo</target></relation><relation type="youtube"><target>http://www.youtube.com/user/KasabianTour</target></relation></relation-list></artist></metadata>') }
    
    before(:each) do
      MusicBrainz.clear_cache
    end
    
    after(:each) do
      MusicBrainz.clear_cache
    end
    
    context 'with cache enabled' do
      it 'calls get contents only once when requesting the resource twice' do
        MusicBrainz.cache_path = cache_path
        MusicBrainz.stub(:get_contents).and_return(response)
        MusicBrainz.should_receive(:get_contents).once
        mbid = '69b39eab-6577-46a4-a9f5-817839092033'
        File.exist?("#{cache_path}/artist/#{mbid}?inc=url-rels").should be_false
        artist = MusicBrainz::Artist.find(mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        
        File.exist?("#{cache_path}/artist/#{mbid}?inc=url-rels").should be_true
        artist = MusicBrainz::Artist.find(mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
      end
    end
    
    context 'with cache disabled' do
      it 'calls get contents twice when requesting the resource twice' do
        MusicBrainz.cache_path = nil
        MusicBrainz.stub(:get_contents).and_return(response)
        MusicBrainz.should_receive(:get_contents).twice
        mbid = '69b39eab-6577-46a4-a9f5-817839092033'
        File.exist?("#{cache_path}/artist/#{mbid}?inc=url-rels").should be_false
        artist = MusicBrainz::Artist.find(mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        
        File.exist?("#{cache_path}/artist/#{mbid}?inc=url-rels").should be_false
        response.rewind
        MusicBrainz.stub(:get_contents).and_return(response)
        artist = MusicBrainz::Artist.find(mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
      end
    end
  end
end
