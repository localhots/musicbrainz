require 'helper'

class TestMusicbrainzRelease < Test::Unit::TestCase
  context "release" do
    should "load xml" do
      assert_nothing_raised(Exception) do
        MusicBrainz::Release.find('2225dd4c-ae9a-403b-8ea0-9e05014c778f')
      end
    end
  
    setup do
      @release = MusicBrainz::Release.find('2225dd4c-ae9a-403b-8ea0-9e05014c778f')
    end
  
    should "return valid instance" do
      assert_instance_of(MusicBrainz::Release, @release)
    end
  
    should "contain correct data" do
      assert_equal("2225dd4c-ae9a-403b-8ea0-9e05014c778f", @release.id)
      assert_equal("Empire", @release.title)
      assert_equal("Official", @release.status)
      assert_equal(Time.utc(2006, 8, 28), @release.date)
      assert_equal("GB", @release.country)
    end
  
    should "load tracks" do
      tracks = @release.tracks
      assert_equal(11, tracks.length)
      assert_equal(1, tracks.first.position)
      assert_equal('b3015bab-1540-4d4e-9f30-14872a1525f7', tracks.first.recording_id)
      assert_equal('Empire', tracks.first.title)
      assert_equal(233013, tracks.first.length)
    end
  end
end
