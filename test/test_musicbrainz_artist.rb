require 'helper'

class TestMusicbrainzArtist < Test::Unit::TestCase
  context "artist" do
    should "load artist xml" do
      assert_nothing_raised(Exception) do
        MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
      end
    end
    
    should "search by name" do
      matches = MusicBrainz::Artist.search('Kasabian')
      assert_operator(0, :<, matches.length)
      assert_equal("Kasabian", matches.first[:name])
    end
    
    should "get correct result by name" do
      @artist = MusicBrainz::Artist.find_by_name('Kasabian')
      assert_equal("69b39eab-6577-46a4-a9f5-817839092033", @artist.id)
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
      assert_equal('533cbc5f-ec7e-32ab-95f3-8d1f804a5176', release_groups.first.id)
      assert_equal('Single', release_groups.first.type)
      assert_equal('Club Foot', release_groups.first.title)
      assert_equal(Time.utc(2004, 5, 10), release_groups.first.first_release_date)
    end
  end
end
