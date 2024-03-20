require "spec_helper"

describe MusicBrainz::ReleaseGroup do
  before(:each) {
    mock url: 'http://musicbrainz.org/ws/2/release-group/6f33e0f0-cde2-38f9-9aee-2c60af8d1a61?inc=url-rels',
         fixture: 'release_group/find_6f33e0f0-cde2-38f9-9aee-2c60af8d1a61.xml'

    mock url: 'http://musicbrainz.org/ws/2/release-group?query=artist:"Kasabian" AND releasegroup:"Empire"&limit=10',
             fixture: 'release_group/search_kasabian_empire.xml'

    mock url: 'http://musicbrainz.org/ws/2/release-group?query=artist:"Kasabian" AND releasegroup:"Empire" AND type:"Album"&limit=10',
             fixture: 'release_group/search_kasabian_empire_album.xml'

    mock url: 'http://musicbrainz.org/ws/2/release?release-group=6f33e0f0-cde2-38f9-9aee-2c60af8d1a61&inc=media+release-groups&limit=100',
         fixture: 'release/list_6f33e0f0-cde2-38f9-9aee-2c60af8d1a61.xml'
  }

  describe '.find' do
    let(:release_group) {
      MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
    }

    it "gets no exception while loading release group info" do
      expect { release_group }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      expect(release_group).to be_an_instance_of(MusicBrainz::ReleaseGroup)
    end

    it "gets correct release group data" do
      expect(release_group.id).to eq "6f33e0f0-cde2-38f9-9aee-2c60af8d1a61"
      expect(release_group.type).to eq "Album"
      expect(release_group.title).to eq "Empire"
      expect(release_group.first_release_date).to eq Date.new(2006, 8, 28)
      expect(release_group.urls[:wikipedia]).to eq 'http://en.wikipedia.org/wiki/Empire_(Kasabian_album)'
    end
  end

  describe '.search' do
    context 'without type filter' do
      let(:matches) {
        MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire')
      }

      it "searches release group by artist name and title" do
        expect(matches.length).to be > 0
        expect(matches.first[:title]).to eq 'Empire'
        expect(matches.first[:type]).to eq 'Album'
      end
    end

    context 'with type filter' do
      let(:matches) {
        MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire', 'Album')
      }

      it "searches release group by artist name and title" do
        expect(matches.length).to be > 0
        expect(matches.first[:title]).to eq 'Empire'
        expect(matches.first[:type]).to eq 'Album'
      end
    end
  end

  describe '.find_by_artist_and_title' do
    let(:release_group) {
      MusicBrainz::ReleaseGroup.find_by_artist_and_title('Kasabian', 'Empire')
    }

    it "gets first release group by artist name and title" do
      expect(release_group.id).to eq '6f33e0f0-cde2-38f9-9aee-2c60af8d1a61'
    end
  end

  describe '#releases' do
    let(:releases) {
      MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61").releases
    }

    it "gets correct release group's releases" do
      expect(releases.length).to be >= 5
      expect(releases.first.id).to eq "2225dd4c-ae9a-403b-8ea0-9e05014c778f"
      expect(releases.first.status).to eq "Official"
      expect(releases.first.title).to eq "Empire"
      expect(releases.first.date).to eq Date.new(2006, 8, 28)
      expect(releases.first.country).to eq "GB"
      expect(releases.first.type).to eq "Album"
    end
  end
end
