require "spec_helper"

describe MusicBrainz::Bindings::Medium do
  describe '.parse' do
    subject(:parse) { described_class.parse(xml) }

    let(:xml) { Nokogiri::XML(<<~XML).at_xpath('medium') }
      <medium>
        <position>1</position>
        <format id="9712d52a-4509-3d4b-a1a2-67c88c643e31">CD</format>
      </medium>
    XML

    it 'contains medium attributes' do
      expect(parse).to include(position: '1', format: 'CD')
    end
  end
end
