require "spec_helper"

describe MusicBrainz::Bindings::Recording do
  describe '.parse' do
    subject(:parse) { described_class.parse(xml) }

    let(:xml) { Nokogiri::XML(<<~XML).at_xpath('recording') }
      <recording id="b3015bab-1540-4d4e-9f30-14872a1525f7">
        <title>Empire</title>
        <length>233013</length>
        <first-release-date>2006-08-25</first-release-date>
        <isrc-list count="1">
          <isrc id="JPB600760301"/>
        </isrc-list>
      </recording>
    XML

    it 'contains recording attributes' do
      expect(parse).to include(
        id: 'b3015bab-1540-4d4e-9f30-14872a1525f7',
        mbid: 'b3015bab-1540-4d4e-9f30-14872a1525f7', title: 'Empire',
        isrcs: ['JPB600760301']
      )
    end
  end
end
