require "spec_helper"

describe MusicBrainz::Recording do
  describe '.find' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/recording/b3015bab-1540-4d4e-9f30-14872a1525f7?',
           fixture: 'recording/find_b3015bab-1540-4d4e-9f30-14872a1525f7.xml'
    }
    let(:recording) {
      MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
    }

    it "gets no exception while loading release info" do
      expect{ recording }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      expect(recording).to be_an_instance_of(MusicBrainz::Recording)
    end

    it "gets correct track data" do
      expect(recording.title).to eq "Empire"
    end
  end

  describe '.search' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/recording?query=recording:"Bound+for+the+floor" AND artist:"Local+H"&limit=10',
           fixture: 'recording/search_bound_for_the_floor_local_h.xml'
    }
    let(:matches) {
      MusicBrainz::Recording.search('Bound for the floor', 'Local H')
    }

    it "searches tracks (aka recordings) by artist name and title" do
      expect(matches).to_not be_empty
      expect(matches.first[:id]).to eq 'bb940e26-4265-4909-b128-4906d8b1079e'
      expect(matches.first[:title]).to eq "Bound for the Floor"
      expect(matches.first[:artist]).to eq "Local H"
    end
  end
end
