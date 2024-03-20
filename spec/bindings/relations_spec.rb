require "spec_helper"

describe MusicBrainz::Bindings::Relations do
  describe '.parse' do
    describe 'attributes' do
      describe 'urls' do
        context '1 url for relation type' do
          let(:response) {
            <<-XML
              <artist>
                <relation-list target-type="url">
                  <relation type="social network" type-id="99429741-f3f6-484b-84f8-23af51991770">
                    <target id="4f4068cb-7001-47a3-a2fe-9146eb6b5d16">https://plus.google.com/+Madonna</target>
                  </relation>
                </relation-list>
              </artist>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:artist) {
            described_class.parse(xml.xpath('./artist'))
          }

          it 'returns a string' do
            expect(artist[:urls][:social_network]).to eq 'https://plus.google.com/+Madonna'
          end
        end

        context 'multiple urls for relation types' do
          let(:response) {
            <<-XML
              <artist>
                <relation-list target-type="url">
                  <relation type="social network" type-id="99429741-f3f6-484b-84f8-23af51991770">
                    <target id="4f4068cb-7001-47a3-a2fe-9146eb6b5d16">https://plus.google.com/+Madonna</target>
                  </relation>
                  <relation type="social network" type-id="99429741-f3f6-484b-84f8-23af51991770">
                    <target id="1dc9e14d-ebfb-448c-a005-e3481d320595">https://www.facebook.com/madonna</target>
                  </relation>
                </relation-list>
              </artist>
            XML
          }
          let(:xml) {
            Nokogiri::XML.parse(response)
          }
          let(:artist) {
            described_class.parse(xml.xpath('./artist'))
          }

          it 'returns an array' do
            expect(artist[:urls][:social_network]).to eq [
              'https://plus.google.com/+Madonna',
              'https://www.facebook.com/madonna',
            ]
          end
        end
      end
    end
  end
end
