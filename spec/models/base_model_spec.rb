# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::BaseModel do
  describe '#validate_type' do
    describe 'Date' do
      let(:xml) { Nokogiri::XML.parse(response) }
      let(:release_group) { MusicBrainz::ReleaseGroup.new MusicBrainz::Bindings::ReleaseGroup.parse(xml) }
      
      context 'when the vale is nil' do
        let(:response) { '<release-group><first-release-date></first-release-date></release-group>' }
        
        it 'returns a Date object corresponding to 2030-12-31' do
          release_group.first_release_date.should == Date.new(2030, 12, 31)
        end
      end
      
      context 'when the value contains only the year' do
        let(:response) { '<release-group><first-release-date>1995</first-release-date></release-group>' }
        
        it 'returns a Date object corresponding to the last day of the year' do
          release_group.first_release_date.should == Date.new(1995, 12, 31)
        end
      end
      
      context 'when the value contains only the year and the month' do
        let(:response) { '<release-group><first-release-date>1995-04</first-release-date></release-group>' }
        
        it 'returns a Date object corresponding to the last day of the month' do
          release_group.first_release_date.should == Date.new(1995, 4, 30)
        end
      end
      
      context 'when the value contains the year, month and day' do
        let(:response) { '<release-group><first-release-date>1995-04-30</first-release-date></release-group>' }
        
        it 'returns the corresponding Date object' do
          release_group.first_release_date.should == Date.new(1995, 4, 30)
        end
      end
    end
  end
end