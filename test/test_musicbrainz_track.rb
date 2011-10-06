require 'helper'

class TestMusicbrainzTrack < Test::Unit::TestCase
  context "track" do
    should "load xml" do
      assert_nothing_raised(Exception) do
        MusicBrainz::Track.find('b3015bab-1540-4d4e-9f30-14872a1525f7')
      end
    end
    
    setup do
      @track = MusicBrainz::Track.find('b3015bab-1540-4d4e-9f30-14872a1525f7')
    end
    
    should "return valid instance" do
      assert_instance_of(MusicBrainz::Track, @track)
    end
    
    should "contain correct data" do
      assert_equal("b3015bab-1540-4d4e-9f30-14872a1525f7", @track.recording_id)
      assert_equal("Empire", @track.title)
      assert_equal(233013, @track.length)
    end
  end
end
