require "spec_helper"

describe MusicBrainz::Artist do
  describe '.search' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/artist?query=artist:"Kasabian"&limit=10',
           fixture: 'artist/search_kasabian.xml'
    }
    let(:matches) {
      MusicBrainz::Artist.search('Kasabian')
    }

    it "searches artist by name" do
      expect(matches).to_not be_empty
      expect(matches.first[:name]).to eq("Kasabian")
    end

    it "should return search results in the right order and pass back the correct score" do
      expect(matches.length).to be >= 2
      expect(matches[0][:score]).to eq 100
      expect(matches[0][:id]).to eq "69b39eab-6577-46a4-a9f5-817839092033"
      expect(matches[1][:score]).to eq 73
      expect(matches[1][:id]).to eq "d76aed40-1332-44db-9b19-aee7ec17464b"
    end
  end

  describe '.find' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/artist/69b39eab-6577-46a4-a9f5-817839092033?inc=url-rels',
           fixture: 'artist/find_69b39eab-6577-46a4-a9f5-817839092033.xml'
    }
    let(:artist) {
      MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
    }

    it "gets no exception while loading artist info" do
      expect{ artist }.to_not raise_error(Exception)
      expect(artist.id).to eq '69b39eab-6577-46a4-a9f5-817839092033'
      expect(artist.name).to eq 'Kasabian'
    end
  end

  describe '.find_by_name' do
    before(:each) {
      mock url: 'http://musicbrainz.org/ws/2/artist?query=artist:"Kasabian"&limit=10',
           fixture: 'artist/search_kasabian.xml'
      mock url: 'http://musicbrainz.org/ws/2/artist/69b39eab-6577-46a4-a9f5-817839092033?inc=url-rels',
           fixture: 'artist/find_69b39eab-6577-46a4-a9f5-817839092033.xml'
    }
    let(:artist) {
      MusicBrainz::Artist.find_by_name('Kasabian')
    }

    it "gets correct instance" do
      expect(artist).to be_instance_of(MusicBrainz::Artist)
    end

    it "gets correct result by name" do
      expect(artist.id).to eq "69b39eab-6577-46a4-a9f5-817839092033"
    end

    it "gets correct artist data" do
      expect(artist.id).to eq "69b39eab-6577-46a4-a9f5-817839092033"
      expect(artist.type).to eq "Group"
      expect(artist.name).to eq "Kasabian"
      expect(artist.country).to eq "GB"
      expect(artist.date_begin.year).to eq 1997
    end

    describe '#release_groups' do
      before(:each) {
        mock url: 'http://musicbrainz.org/ws/2/release-group?artist=69b39eab-6577-46a4-a9f5-817839092033&inc=url-rels',
             fixture: 'artist/release_groups_69b39eab-6577-46a4-a9f5-817839092033.xml'
      }
      let(:release_groups) {
        artist.release_groups
      }

      it "gets correct artist's release groups" do
        release_groups = MusicBrainz::Artist.find_by_name('Kasabian').release_groups
        expect(release_groups.length).to be >= 16
        expect(release_groups.first.id).to eq "5547285f-578f-3236-85aa-b65cc0923b58"
        expect(release_groups.first.type).to eq "Single"
        expect(release_groups.first.title).to eq "Reason Is Treason"
        expect(release_groups.first.first_release_date).to eq Date.new(2004, 2, 23)
        expect(release_groups.first.urls[:discogs]).to eq 'https://www.discogs.com/master/125172'
      end
    end
  end
end
