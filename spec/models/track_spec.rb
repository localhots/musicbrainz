require "spec_helper"

describe MusicBrainz::Track do
  describe '.find' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/recording/b3015bab-1540-4d4e-9f30-14872a1525f7?',
           fixture: 'recording/find_b3015bab-1540-4d4e-9f30-14872a1525f7.xml'
    }
    let(:track) {
      MusicBrainz::Track.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
    }

    it "gets no exception while loading release info" do
      expect { track }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      expect(track).to be_an_instance_of(MusicBrainz::Track)
    end

    it "gets correct track data" do
      expect(track.recording_id).to eq "b3015bab-1540-4d4e-9f30-14872a1525f7"
      expect(track.title).to eq "Empire"
      expect(track.length).to eq 233013
    end
  end
end
