require 'helper'

class TestMusicbrainz < Test::Unit::TestCase
  context "artist" do
    should "load artist xml" do
      assert_nothing_raised(Exception) do
        MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
      end
    end
    
    setup do
      @artist = MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
    end
    
    should "return valid instance" do
      assert_instance_of(MusicBrainz::Artist, @artist)
    end
    
    should "contain correct data" do
      assert_equal("69b39eab-6577-46a4-a9f5-817839092033", @artist.id)
      assert_equal("Group", @artist.type)
      assert_equal("Kasabian", @artist.name)
      assert_equal("GB", @artist.country)
      assert_equal("1999", @artist.date_begin)
    end
    
    should "load release groups" do
      release_groups = @artist.release_groups
      assert_operator(16, :<=, release_groups.length)
      assert_equal('0244b82e-0796-36fc-a629-2507d5441124', release_groups[0].id)
      assert_equal('Single', release_groups[0].type)
      assert_equal('Shoot the Runner', release_groups[0].title)
      assert_equal(Time.parse('2006-01-01'), release_groups[0].first_release_date)
    end
  end
  
  context "release group" do
    should "load release group xml" do
      assert_nothing_raised(Exception) do
        MusicBrainz::ReleaseGroup.find('6f33e0f0-cde2-38f9-9aee-2c60af8d1a61')
      end
    end
    
    setup do
      @release_group = MusicBrainz::ReleaseGroup.find('6f33e0f0-cde2-38f9-9aee-2c60af8d1a61')
    end
    
    should "return valid instance" do
      assert_instance_of(MusicBrainz::ReleaseGroup, @release_group)
    end
    
    should "contain correct data" do
      assert_equal("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61", @release_group.id)
      assert_equal("Album", @release_group.type)
      assert_equal("Empire", @release_group.title)
      assert_equal(Time.parse('2006-08-28'), @release_group.first_release_date)
    end
    
    should "load releases" do
      releases = @release_group.releases
      assert_operator(5, :<=, releases.length)
      assert_equal('2225dd4c-ae9a-403b-8ea0-9e05014c778f', releases[0].id)
      assert_equal('Official', releases[0].status)
      assert_equal('Empire', releases[0].title)
      assert_equal(Time.parse('2006-08-28'), releases[0].date)
      assert_equal('GB', releases[0].country)
    end
  end
  
  context "release" do
    should "load release xml" do
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
      assert_equal(Time.parse('2006-08-28'), @release.date)
      assert_equal("GB", @release.country)
    end
    
    should "load tracks" do
      tracks = @release.tracks
      assert_equal(11, tracks.length)
      assert_equal(1, tracks[0].position)
      assert_equal('b3015bab-1540-4d4e-9f30-14872a1525f7', tracks[0].recording_id)
      assert_equal('Empire', tracks[0].title)
      assert_equal(233013, tracks[0].length)
    end
  end
  
  context "track" do
    should "load track xml" do
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
