# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Artist do
  it "gets no exception while loading artist info" do
    expect {
      MusicBrainz::Artist.find('69b39eab-6577-46a4-a9f5-817839092033')
    }.to_not raise_error(Exception)
  end

  it "gets correct instance" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    expect(artist).to be_instance_of(MusicBrainz::Artist)
  end

  it "searches artist by name" do
    matches = MusicBrainz::Artist.search('Kasabian')
    expect(matches).to_not be_empty
    expect(matches.first[:name]).to eq("Kasabian")
  end

  it "should return search results in the right order and pass back the correct score" do
    response = File.open(File.join(File.dirname(__FILE__), "../fixtures/artist/search.xml")).read
    allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
      .with('http://musicbrainz.org/ws/2/artist?query=artist:"Chris+Martin"&limit=10')
      .and_return({ status: 200, body: response})

    matches = MusicBrainz::Artist.search('Chris Martin')

    expect(matches[0][:score]).to eq 100
    expect(matches[0][:id]).to eq "90fff570-a4ef-4cd4-ba21-e00c7261b05a"
    expect(matches[1][:score]).to eq 100
    expect(matches[1][:id]).to eq "b732a912-af95-472c-be52-b14610734c64"
  end

  it "gets correct result by name" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    expect(artist.id).to eq "69b39eab-6577-46a4-a9f5-817839092033"
  end

  it "gets correct artist data" do
    artist = MusicBrainz::Artist.find_by_name('Kasabian')
    expect(artist.id).to eq "69b39eab-6577-46a4-a9f5-817839092033"
    expect(artist.type).to eq "Group"
    expect(artist.name).to eq "Kasabian"
    expect(artist.country).to eq "GB"
    expect(artist.date_begin.year).to eq 1997
  end

  it "gets correct artist's release groups" do
    release_groups = MusicBrainz::Artist.find_by_name('Kasabian').release_groups
    expect(release_groups.length).to be >= 16
    expect(release_groups.first.id).to eq "533cbc5f-ec7e-32ab-95f3-8d1f804a5176"
    expect(release_groups.first.type).to eq "Single"
    expect(release_groups.first.title).to eq "Club Foot"
    expect(release_groups.first.first_release_date).to eq Date.new(2004, 5, 10)
    expect(release_groups.first.urls[:discogs]).to eq 'http://www.discogs.com/master/125150'
  end
end
