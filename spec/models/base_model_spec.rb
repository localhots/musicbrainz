# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MusicBrainz::BaseModel do
  
  describe 'InstanceMethods' do

    class MusicBrainz::BaseModelSubclass < MusicBrainz::BaseModel
    end
    
    subject { MusicBrainz::BaseModelSubclass.new }
    
    describe '#validate_date' do
      let(:validated_date) { subject.send(:validate_date, value) }
      
      context 'when the value is nil' do
        let(:value) { nil }
      
        it 'returns a Date object corresponding to 2030-12-31' do
          validated_date.should == Date.new(2030, 12, 31)
        end
      end
    
      context 'when the value contains only the year' do
        let(:value) { '1995' }
      
        it 'returns a Date object corresponding to the last day of the year' do
          validated_date.should == Date.new(1995, 12, 31)
        end
      end
    
      context 'when the value contains only the year and the month' do
        let(:value) { '1995-04' }
      
        it 'returns a Date object corresponding to the last day of the month' do
          validated_date.should == Date.new(1995, 4, 30)
        end
      end
    
      context 'when the value contains the year, month and day' do
        let(:value) { '1995-04-30' }
      
        it 'returns the corresponding Date object' do
          validated_date.should == Date.new(1995, 4, 30)
        end
      end
    end

  end
end