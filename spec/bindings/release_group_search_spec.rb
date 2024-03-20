require "spec_helper"

describe MusicBrainz::Bindings::ReleaseGroupSearch do
  describe '.parse' do
    let(:response) {
      <<-XML
        <metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#" xmlns:ext="http://musicbrainz.org/ns/ext#-2.0">
          <release-group-list>
            <release-group ext:score="100" id="246bc928-2dc8-35ba-80ee-7a0079de1632" type="Single">
              <title>Empire</title>
            </release-group>
          </release-group-list>
        </metadata>
      XML
    }
    let(:xml) {
      Nokogiri::XML.parse(response)
    }
    let(:metadata) {
      described_class.parse(xml.remove_namespaces!.xpath('/metadata'))
    }

    it "gets correct release group data" do
      expect(metadata).to eq [
        {
          id: '246bc928-2dc8-35ba-80ee-7a0079de1632',
          mbid: '246bc928-2dc8-35ba-80ee-7a0079de1632',
          title: 'Empire',
          type: 'Single',
          score: 100,
        }
      ]
    end
  end
end
