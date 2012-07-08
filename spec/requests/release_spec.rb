# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Release do
  it "gets no exception while loading release info" do
    lambda {
      MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    }.should_not raise_error(Exception)
  end

  it "gets correct instance" do
    release = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    release.should be_an_instance_of(MusicBrainz::Release)
  end

  it "gets correct release data" do
    release = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    release.id.should == "2225dd4c-ae9a-403b-8ea0-9e05014c778f"
    release.title.should == "Empire"
    release.status.should == "Official"
    release.date.should == Time.utc(2006, 8, 28)
    release.country.should == "GB"
  end

  it "gets correct release tracks" do
    tracks = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f").tracks
    tracks.length.should == 11
    tracks.first.position.should == 1
    tracks.first.recording_id.should == "b3015bab-1540-4d4e-9f30-14872a1525f7"
    tracks.first.title.should == "Empire"
    tracks.first.length.should == 233013
  end
end
