require "spec_helper"

describe MusicBrainz::Bindings::Release do
  describe '.parse' do
    describe 'attributes' do
      describe 'format' do
        context 'single cd' do
          let(:response) {
            <<-XML
              <release>
                <medium-list count="1">
                  <medium>
                    <format>CD</format>
                  </medium>
                </medium-list>
              </release>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:release) {
            described_class.parse(xml)
          }

          it 'returns CD' do
            expect(release[:format]).to eq 'CD'
          end
        end

        context 'multiple cds' do
          let(:response) {
            <<-XML
              <release>
                <medium-list count="2">
                  <medium>
                    <format>CD</format>
                    <track-list count="11"/>
                  </medium>
                  <medium>
                    <title>bonus disc</title>
                    <format>CD</format>
                  </medium>
                </medium-list>
              </release>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:release) {
            described_class.parse(xml)
          }

          it 'returns 2xCD' do
            expect(release[:format]).to eq '2xCD'
          end
        end

        context 'different formats' do
          let(:response) {
            <<-XML
              <release>
                <medium-list count="2">
                  <medium>
                    <format>DVD</format>
                  </medium>
                  <medium>
                    <format>CD</format>
                  </medium>
                </medium-list>
              </release>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:release) {
            described_class.parse(xml)
          }

          it 'returns DVD + CD' do
            expect(release[:format]).to eq 'DVD + CD'
          end
        end

        context 'different formats plus multiple mediums with same format' do
          let(:response) {
            <<-XML
              <release>
                <medium-list count="2">
                  <medium>
                    <format>CD</format>
                  </medium>
                  <medium>
                    <format>CD</format>
                  </medium>
                  <medium>
                    <format>DVD</format>
                  </medium>
                </medium-list>
              </release>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:release) {
            described_class.parse(xml)
          }

          it 'returns 2xCD + DVD' do
            expect(release[:format]).to eq '2xCD + DVD'
          end
        end
      end
    end
  end
end
