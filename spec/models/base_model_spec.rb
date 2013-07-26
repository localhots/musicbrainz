# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::BaseModel do
  describe '#validate_type' do
    describe 'Date' do
      let(:xml) { Nokogiri::XML.parse(response) }
      let(:release_group) { MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml) }
      
      context 'nil value' do
        let(:response) { '<release-group><first-release-date></first-release-date></release-group>' }
        
        it 'returns 2030-12-31' do
          release_group.first_release_date.should == Date.new(2030, 12, 31)
        end
      end
      
      context 'year only' do
        let(:response) { '<release-group><first-release-date>1995</first-release-date></release-group>' }
        
        it 'returns 1995-12-31' do
          release_group.first_release_date.should == Date.new(1995, 12, 31)
        end
      end
      
      context 'year and month only' do
        let(:response) { '<release-group><first-release-date>1995-04</first-release-date></release-group>' }
        
        it 'returns 1995-04-30' do
          release_group.first_release_date.should == Date.new(1995, 4, 30)
        end
      end
      
      context 'year, month and day' do
        let(:response) { '<release-group><first-release-date>1995-04-30</first-release-date></release-group>' }
        
        it 'returns 1995-04-30' do
          release_group.first_release_date.should == Date.new(1995, 4, 30)
        end
      end
    end
  end
end