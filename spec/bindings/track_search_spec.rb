# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Bindings::TrackSearch do
  describe '.parse' do
    it "gets correct Track (really recording) data" do
			response = '<metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#" xmlns:ext="http://musicbrainz.org/ns/ext#-2.0"><recording-list offset="0" count="1"><recording id="0b382a13-32f0-4743-9248-ba5536a6115e" ext:score="100"><title>King Fred</title><artist-credit><name-credit><artist id="f52f7a92-d495-4d32-89e7-8b1e5b8541c8"><name>Too Much Joy</name></artist></name-credit></artist-credit><release-list><release id="8442e42b-c40a-4817-89a0-dbe663c94d2d"><title>Green Eggs and Crack</title></release></release-list></recording></recording-list></metadata>'
      expect(described_class.parse(Nokogiri::XML.parse(response).remove_namespaces!.xpath('/metadata'))).to eq [
        {
          id: '0b382a13-32f0-4743-9248-ba5536a6115e', mbid: '0b382a13-32f0-4743-9248-ba5536a6115e',
          title: 'King Fred', artist: 'Too Much Joy', releases: ['Green Eggs and Crack'], score: 100
        }
      ]
    end
  end
end
