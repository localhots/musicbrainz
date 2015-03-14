# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::BaseModel do
  describe '#validate_type' do
    describe 'Date' do
      context 'nil value' do
        it 'returns 2030-12-31' do
          response = '<release-group><first-release-date></first-release-date></release-group>'
          xml = Nokogiri::XML.parse(response)
          release_group = MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml)
          expect(release_group.first_release_date).to eq Date.new(2030, 12, 31)
        end
      end

      context 'year only' do
        it 'returns 1995-12-31' do
          response = '<release-group><first-release-date>1995</first-release-date></release-group>'
          xml = Nokogiri::XML.parse(response)
          release_group = MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml)
          expect(release_group.first_release_date).to eq Date.new(1995, 12, 31)
        end
      end

      context 'year and month only' do
        it 'returns 1995-04-30' do
          response = '<release-group><first-release-date>1995-04</first-release-date></release-group>'
          xml = Nokogiri::XML.parse(response)
          release_group = MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml)
          expect(release_group.first_release_date).to eq Date.new(1995, 4, 30)
        end
      end

      context 'year, month and day' do
        it 'returns 1995-04-30' do
          response = '<release-group><first-release-date>1995-04-30</first-release-date></release-group>'
          xml = Nokogiri::XML.parse(response)
          release_group = MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml)
          expect(release_group.first_release_date).to eq Date.new(1995, 4, 30)
        end
      end
    end
  end
end
