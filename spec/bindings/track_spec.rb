require "spec_helper"

describe MusicBrainz::Bindings::Track do
  describe '.parse' do
    subject(:parse) { described_class.parse(xml) }

    let(:xml) { Nokogiri::XML(<<~XML).at_xpath('track') }
      <track id="0501cf38-48b7-3026-80d2-717d574b3d6a">
        <position>1</position>
        <number>1</number>
        <length>233013</length>
        <recording id="b3015bab-1540-4d4e-9f30-14872a1525f7">
          <title>Empire</title>
          <length>233013</length>
          <first-release-date>2006-08-25</first-release-date>
        </recording>
      </track>
    XML

    it 'contains track attributes' do
      expect(parse).to include(
        id: '0501cf38-48b7-3026-80d2-717d574b3d6a', position: '1', length: '233013',
        recording_id: 'b3015bab-1540-4d4e-9f30-14872a1525f7', title: 'Empire'
      )
    end
  end
end
