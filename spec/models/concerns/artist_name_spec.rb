# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Concerns::ArtistName do
  it 'principally works' do
    recording = MusicBrainz::Recording.from_xml(
      '<recording><artist-credit>' +
      "<name-credit joinphrase=' &amp; '><artist><name>Artist 1</name></artist></name-credit>" +
      '<name-credit><artist><name>Artist 2</name></artist></name-credit>' +
      '</artist-credit></recording>'
    )

    recording.artist_name.should == 'Artist 1 & Artist 2'
  end
  
  it 'principally works' do
    recording = MusicBrainz::Recording.from_xml(%Q{
      <recording>
        <artist-credit>
          <name-credit joinphrase=" feat. "><artist><name>Artist 1</name></artist></name-credit>
          <name-credit joinphrase=" and "><artist><name>Artist 2</name></artist></name-credit>
          <name-credit><artist><name>Artist 3</name></artist></name-credit>
        </artist-credit>
      </recording> 
    })

    recording.artist_name.should == 'Artist 1 feat. Artist 2 and Artist 3'
  end
end