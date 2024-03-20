require "spec_helper"

describe MusicBrainz::Release do
  before(:each) {
    mock url: 'http://musicbrainz.org/ws/2/release/2225dd4c-ae9a-403b-8ea0-9e05014c778f?inc=media+release-groups',
         fixture: 'release/find_2225dd4c-ae9a-403b-8ea0-9e05014c778f.xml'

    mock url: 'http://musicbrainz.org/ws/2/release/2225dd4c-ae9a-403b-8ea0-9e05014c778f?inc=recordings+media&limit=100',
         fixture: 'release/find_2225dd4c-ae9a-403b-8ea0-9e05014c778f_tracks.xml'

    mock url: 'http://musicbrainz.org/ws/2/release/b94cb547-cf7a-4357-894c-53c3bf33b093?inc=media+release-groups',
         fixture: 'release/find_b94cb547-cf7a-4357-894c-53c3bf33b093.xml'

    mock url: 'http://musicbrainz.org/ws/2/discid/pmzhT6ZlFiwSRCdVwV0eqire5_Y-?',
         fixture: 'release/find_by_discid_pmzhT6ZlFiwSRCdVwV0eqire5_Y-.xml'
  }

  describe '.find' do
    let(:release) {
      MusicBrainz::Release.find("b94cb547-cf7a-4357-894c-53c3bf33b093")
    }

    it "gets no exception while loading release info" do
      expect { release }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      expect(release).to be_an_instance_of(MusicBrainz::Release)
    end

    it "gets correct release data" do
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
  end

  describe '#tracks' do
    let(:release) {
      MusicBrainz::Release.find("2225dd4c-ae9a-403b-8ea0-9e05014c778f")
    }
    let(:tracks) {
      release.tracks
    }

    it "gets correct release tracks" do
      expect(tracks.length).to eq 11
      expect(tracks.first.position).to eq 1
      expect(tracks.first.recording_id).to eq "b3015bab-1540-4d4e-9f30-14872a1525f7"
      expect(tracks.first.title).to eq "Empire"
      expect(tracks.first.length).to eq 233013
    end
  end

  describe '.find_by_discid' do
    let(:releases) {
      MusicBrainz::Release.find_by_discid("pmzhT6ZlFiwSRCdVwV0eqire5_Y-")
    }

    it "gets a list of matching releases for a discid" do
      expect(releases.length).to eq 2
      expect(releases.first.id).to eq "7a31cd5f-6a57-4fca-a731-c521df1d3b78"
      expect(releases.first.title).to eq "Kveikur"
      expect(releases.first.asin).to eq "B00C1GBOU6"
    end
  end
end
