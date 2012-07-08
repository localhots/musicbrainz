# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Track do
  it "gets no exception while loading release info" do
    lambda {
      MusicBrainz::Track.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
    }.should_not raise_error(Exception)
  end

  it "gets correct instance" do
    track = MusicBrainz::Track.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
    track.should be_an_instance_of(MusicBrainz::Track)
  end

  it "gets correct track data" do
    track = MusicBrainz::Track.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
    track.recording_id.should == "b3015bab-1540-4d4e-9f30-14872a1525f7"
    track.title.should == "Empire"
    track.length.should == 233013
  end
end
