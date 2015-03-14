# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Release do
  it "gets no exception while loading release info" do
    expect {
      MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    }.to_not raise_error(Exception)
  end

  it "gets correct instance" do
    release = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    expect(release).to be_an_instance_of(MusicBrainz::Release)
  end

  it "gets correct release data" do
    release = MusicBrainz::Release.find("b94cb547-cf7a-4357-894c-53c3bf33b093")
    expect(release.id).to eq "b94cb547-cf7a-4357-894c-53c3bf33b093"
    expect(release.title).to eq "Humanoid"
    expect(release.status).to eq "Official"
    expect(release.date).to eq Date.new(2009, 10, 6)
    expect(release.country).to eq "US"
    expect(release.asin).to eq 'B002NOYX6I'
    expect(release.barcode).to eq '602527197692'
    expect(release.quality).to eq 'normal'
    expect(release.type).to eq 'Album'
  end

  it "gets correct release tracks" do
    tracks = MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f").tracks
    expect(tracks.length).to eq 11
    expect(tracks.first.position).to eq 1
    expect(tracks.first.recording_id).to eq "b3015bab-1540-4d4e-9f30-14872a1525f7"
    expect(tracks.first.title).to eq "Empire"
    expect(tracks.first.length).to eq 233013
  end

  it "gets a list of matching releases for a discid" do
    releases = MusicBrainz::Release.find_by_discid("pmzhT6ZlFiwSRCdVwV0eqire5_Y-")
    expect(releases.length).to eq 2
    expect(releases.first.id).to eq "7a31cd5f-6a57-4fca-a731-c521df1d3b78"
    expect(releases.first.title).to eq "Kveikur"
    expect(releases.first.asin).to eq "B00C1GBOU6"
  end
end
