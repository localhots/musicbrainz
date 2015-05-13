# -*- encoding : utf-8 -*-

require "spec_helper"

describe MusicBrainz::Bindings::ReleaseGroupSearch do
  describe '.parse' do
    let(:response) {
      '<metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#" xmlns:ext="http://musicbrainz.org/ns/ext#-2.0"><release-group-list><release-group id="246bc928-2dc8-35ba-80ee-7a0079de1632" type="Single" ext:score="100"><title>Empire</title></release-group></release-group-list></metadata>'
    }
    let(:metadata) {
      described_class.parse(Nokogiri::XML.parse(response).remove_namespaces!.xpath('/metadata'))
    }

    it "gets correct release group data" do
      expect(metadata).to eq([
        {
          id: '246bc928-2dc8-35ba-80ee-7a0079de1632', mbid: '246bc928-2dc8-35ba-80ee-7a0079de1632',
          title: 'Empire', type: 'Single', score: 100
        }
      ])
    end
  end
end
