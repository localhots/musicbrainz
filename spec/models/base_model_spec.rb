# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MusicBrainz::BaseModel do
  
  describe 'InstanceMethods' do

    class MusicBrainz::BaseModelSubclass < MusicBrainz::BaseModel
    end
    
    subject { MusicBrainz::BaseModelSubclass.new }
    
    describe '#validate_type' do
      context 'when there is a specific implementation for the provided type' do
        let(:type) { [ Integer, Float, String, Date ].sample }
        let(:value) { 'sample value' }
        let(:validate_method) { "validate_#{type.name.downcase}".to_sym }
        
        it 'validates the value with the specific implementation' do
          subject.should_receive(validate_method).with(value)
        end
        
        after { subject.send(:validate_type, value, type) }
      end
      
      context 'when there is not a specific implementation for the provided type' do
        let(:type) { Hash }
        let(:value) { type.new }
        
        it 'returns the provided value' do
          subject.send(:validate_type, value, type).should eql(value)
        end
      end
    end
    
    describe '#validate_integer' do
      let(:value) { '1' }
      
      it 'returns the corresponding Integer object' do
        subject.send(:validate_integer, value).should eql(1)
      end
    end
    
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