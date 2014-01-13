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
    release = MusicBrainz::Release.find("b94cb547-cf7a-4357-894c-53c3bf33b093")
    release.id.should == "b94cb547-cf7a-4357-894c-53c3bf33b093"
    release.title.should == "Humanoid"
    release.status.should == "Official"
    release.date.should == Date.new(2009, 10, 6)
    release.country.should == "US"
    release.asin.should == 'B002NOYX6I'
    release.barcode.should == '602527197692'
    release.quality.should == 'normal'
    release.type.should == 'Album'
  end

  it "gets correct release tracks" do
    tracks = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f").tracks
    tracks.length.should == 11
    tracks.first.position.should == 1
    tracks.first.recording_id.should == "b3015bab-1540-4d4e-9f30-14872a1525f7"
    tracks.first.title.should == "Empire"
    tracks.first.length.should == 233013
  end

  it "gets a list of matching releases for a discid" do
    releases = MusicBrainz::Release.find_by_discid("pmzhT6ZlFiwSRCdVwV0eqire5_Y-")
    releases.length.should == 2
    releases.first.id.should == "7a31cd5f-6a57-4fca-a731-c521df1d3b78"
    releases.first.title.should == "Kveikur"
    releases.first.asin.should == "B00C1GBOU6"
  end
end
