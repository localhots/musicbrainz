# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Artist do
  it "gets no exception while loading artist info" do
    lambda {
      MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
    }.should_not raise_error(Exception)
  end

  it "gets correct instance" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    artist.should be_an_instance_of(MusicBrainz::Artist)
  end

  it "searches artist by name" do
    matches = MusicBrainz::Artist.search('Kasabian')
    matches.length.should be > 0
    matches.first[:name].should == "Kasabian"
  end

  it "should return search results in the right order and pass back the correct score" do
    matches = MusicBrainz::Artist.search('Chris Martin')

    matches[0][:score].should == 100
    matches[0][:id].should == "98d1ec5a-dd97-4c0b-9c83-7928aac89bca"
    matches[1][:score].should == 100
    matches[1][:id].should == "af2ab893-3212-4226-9e73-73a1660b6952"
  end

  it "finds name first than alias" do
    matches = MusicBrainz::Artist.search('Chris Martin')
    matches.length.should be > 0
    matches.first[:mbid].should == "98d1ec5a-dd97-4c0b-9c83-7928aac89bca"
  end

  it "gets correct result by name" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    artist.id.should == "69b39eab-6577-46a4-a9f5-817839092033"
  end

  it "gets correct artist data" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    artist.id.should == "69b39eab-6577-46a4-a9f5-817839092033"
    artist.type.should == "Group"
    artist.name.should == "Kasabian"
    artist.country.should == "GB"
    artist.date_begin.year.should == 1999
  end

  it "gets correct artist's release groups" do
    release_groups = MusicBrainz::Artist.find_by_name('Kasabian').release_groups
    release_groups.length.should be >= 16
    release_groups.first.id.should == "533cbc5f-ec7e-32ab-95f3-8d1f804a5176"
    release_groups.first.type.should == "Single"
    release_groups.first.title.should == "Club Foot"
    release_groups.first.first_release_date.should == Time.utc(2004, 5, 10)
  end
end
