# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::ReleaseGroup do
  it "gets no exception while loading release group info" do
    lambda {
      MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
    }.should_not raise_error(Exception)
  end

  it "gets correct instance" do
    release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
    release_group.should be_an_instance_of(MusicBrainz::ReleaseGroup)
  end

  it "gets correct release group data" do
    release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
    release_group.id.should == "6f33e0f0-cde2-38f9-9aee-2c60af8d1a61"
    release_group.type.should == "Album"
    release_group.title.should == "Empire"
    release_group.first_release_date.should == Time.utc(2006, 8, 28)
  end

  it "gets correct release group's releases" do
    releases = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61").releases
    releases.length.should be >= 5
    releases.first.id.should == "2225dd4c-ae9a-403b-8ea0-9e05014c778f"
    releases.first.status.should == "Official"
    releases.first.title.should == "Empire"
    releases.first.date.should == Time.utc(2006, 8, 28)
    releases.first.country.should == "GB"
  end
end
