# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::ReleaseGroup do
  describe '.find' do
    it "gets no exception while loading release group info" do
      expect {
        MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      }.to_not raise_error(Exception)
    end

    it "gets correct instance" do
      release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      expect(release_group).to be_an_instance_of(MusicBrainz::ReleaseGroup)
    end

    it "gets correct release group data" do
      release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      expect(release_group.id).to eq "6f33e0f0-cde2-38f9-9aee-2c60af8d1a61"
      expect(release_group.type).to eq "Album"
      expect(release_group.title).to eq "Empire"
      expect(release_group.first_release_date).to eq Date.new(2006, 8, 28)
      expect(release_group.urls[:wikipedia]).to eq 'http://en.wikipedia.org/wiki/Empire_(Kasabian_album)'
    end
  end

  describe '.search' do
    context 'without type filter' do
      it "searches release group by artist name and title" do
        response = File.open(File.join(File.dirname(__FILE__), "../fixtures/release_group/search.xml")).read
        allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
          .with('http://musicbrainz.org/ws/2/release-group?query=artist:"Kasabian" AND releasegroup:"Empire"&limit=10')
          .and_return({ status: 200, body: response})

        matches = MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire')
        expect(matches.length).to be > 0
        expect(matches.first[:title]).to eq 'Empire'
        expect(matches.first[:type]).to eq 'Album'
      end
    end

    context 'with type filter' do
      it "searches release group by artist name and title" do
        matches = MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire', 'Album')
        expect(matches.length).to be > 0
        expect(matches.first[:title]).to eq 'Empire'
        expect(matches.first[:type]).to eq 'Album'
      end
    end
  end

  describe '.find_by_artist_and_title' do
    it "gets first release group by artist name and title" do
      response = File.open(File.join(File.dirname(__FILE__), "../fixtures/release_group/search.xml")).read
      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
        .with('http://musicbrainz.org/ws/2/release-group?query=artist:"Kasabian" AND releasegroup:"Empire"&limit=10')
        .and_return({ status: 200, body: response})

      response = File.open(File.join(File.dirname(__FILE__), "../fixtures/release_group/entity.xml")).read
      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
        .with('http://musicbrainz.org/ws/2/release-group/6f33e0f0-cde2-38f9-9aee-2c60af8d1a61?inc=url-rels')
        .and_return({ status: 200, body: response})

      release_group = MusicBrainz::ReleaseGroup.find_by_artist_and_title('Kasabian', 'Empire')
      expect(release_group.id).to eq '6f33e0f0-cde2-38f9-9aee-2c60af8d1a61'
    end
  end

  describe '#releases' do
    it "gets correct release group's releases" do
      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
        .with('http://musicbrainz.org/ws/2/release-group/6f33e0f0-cde2-38f9-9aee-2c60af8d1a61?inc=url-rels')
        .and_return({ status: 200, body: File.open(File.join(File.dirname(__FILE__), "../fixtures/release_group/entity.xml")).read})

      allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
        .with('http://musicbrainz.org/ws/2/release?release-group=6f33e0f0-cde2-38f9-9aee-2c60af8d1a61&inc=media+release-groups&limit=100')
        .and_return({ status: 200, body: File.open(File.join(File.dirname(__FILE__), "../fixtures/release/list.xml")).read})

      releases = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61").releases
      expect(releases.length).to be >= 5
      expect(releases.first.id).to eq "30d5e730-ce0a-464d-93e1-7d76e4bb3e31"
      expect(releases.first.status).to eq "Official"
      expect(releases.first.title).to eq "Empire"
      expect(releases.first.date).to eq Date.new(2006, 8, 28)
      expect(releases.first.country).to eq "GB"
      expect(releases.first.type).to eq "Album"
    end
  end
end
