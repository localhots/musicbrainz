# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Recording do
  describe '.find' do
    it "gets no exception while loading release info" do
      expect {
        MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
      }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      track = MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
      expect(track).to be_an_instance_of(MusicBrainz::Recording)
    end

    it "gets correct track data" do
      track = MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
      expect(track.title).to eq "Empire"
    end
  end

  describe '.search' do
    it "searches tracks (aka recordings) by artist name and title" do
      matches = MusicBrainz::Recording.search('Bound for the floor', 'Local H')
      expect(matches.length).to be > 0
      expect(matches.first[:title]).to eq "Bound for the Floor"
      expect(matches.first[:artist]).to eq "Local H"
    end
  end
end
