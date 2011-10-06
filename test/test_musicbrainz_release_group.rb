require 'helper'

class TestMusicbrainzReleaseGroup < Test::Unit::TestCase
  context "release group" do
    should "load xml" do
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
      assert_equal(Time.utc(2006, 8, 28), @release_group.first_release_date)
    end
    
    should "load releases" do
      releases = @release_group.releases
      assert_operator(5, :<=, releases.length)
      assert_equal('2225dd4c-ae9a-403b-8ea0-9e05014c778f', releases.first.id)
      assert_equal('Official', releases.first.status)
      assert_equal('Empire', releases.first.title)
      assert_equal(Time.utc(2006, 8, 28), releases.first.date)
      assert_equal('GB', releases.first.country)
    end
  end
end
