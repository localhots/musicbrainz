require "spec_helper"

describe MusicBrainz::Bindings::Medium do
  describe '.parse' do
    subject(:parse) { described_class.parse(xml) }

    let(:xml) { Nokogiri::XML(<<~XML).at_xpath('medium') }
      <medium>
        <position>1</position>
        <format id="9712d52a-4509-3d4b-a1a2-67c88c643e31">CD</format>
        <track-list>
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
        </track-list>
      </medium>
    XML

    it 'contains medium attributes' do
      expect(parse).to include(position: '1', format: 'CD')
    end

    it 'contains track attributes' do
      expect(parse[:tracks].first).to include(
        id: '0501cf38-48b7-3026-80d2-717d574b3d6a', position: '1', length: '233013',
        recording_id: 'b3015bab-1540-4d4e-9f30-14872a1525f7', title: 'Empire'
      )
    end
  end
end
