require "spec_helper"

describe MusicBrainz::Bindings::RecordingSearch do
  describe '.parse' do
    let(:response) {
      <<-XML
        <metadata xmlns="http://musicbrainz.org/ns/mmd-2.0#" xmlns:ext="http://musicbrainz.org/ns/ext#-2.0">
          <recording-list count="1" offset="0">
            <recording ext:score="100" id="0b382a13-32f0-4743-9248-ba5536a6115e">
              <title>King Fred</title>
              <artist-credit>
                <name-credit>
                  <artist id="f52f7a92-d495-4d32-89e7-8b1e5b8541c8">
                    <name>Too Much Joy</name>
                  </artist>
                </name-credit>
              </artist-credit>
              <release-list>
                <release id="8442e42b-c40a-4817-89a0-dbe663c94d2d">
                  <title>Green Eggs and Crack</title>
                </release>
              </release-list>
            </recording>
          </recording-list>
        </metadata>
      XML
    }
    let(:xml) {
      Nokogiri::XML.parse(response).remove_namespaces!
    }
    let(:metadata) {
      described_class.parse(xml.xpath('/metadata'))
    }

    it "gets correct Recording data" do
      expect(metadata).to eq [
        {
          id: '0b382a13-32f0-4743-9248-ba5536a6115e',
          mbid: '0b382a13-32f0-4743-9248-ba5536a6115e',
          title: 'King Fred',
          artist: 'Too Much Joy',
          releases: ['Green Eggs and Crack'],
          score: 100,
        }
      ]
    end
  end
end
