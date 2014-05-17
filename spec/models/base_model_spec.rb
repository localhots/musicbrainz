# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MusicBrainz::BaseModel do
  
  describe 'InstanceMethods' do

    class MusicBrainz::BaseModelSubclass < MusicBrainz::BaseModel
    end
    
    subject { MusicBrainz::BaseModelSubclass.new }
    
    describe '#parse_type' do
      
      shared_examples 'specific parser' do
        let(:parse_method) { "parse_#{type.name.downcase}".to_sym }

        it 'parses the value with the specific implementation' do
          subject.should_receive(parse_method).with(value)
        end
        
        after { subject.send(:parse_type, value, type) }
      end
      
      context 'when the type is Integer' do
        let(:type) { Integer }
        let(:value) { '1' }
        
        it_should_behave_like 'specific parser'
      end
      
      context 'when the type is Float' do
        let(:type) { Float }
        let(:value) { '0.1' }
        
        it_should_behave_like 'specific parser'
      end
      
      context 'when the type is Date' do
        let(:type) { Date }
        let(:value) { '2013' }
        
        it_should_behave_like 'specific parser'
      end
      
      context 'when there is not a specific parser implementation for the provided type' do
        let(:type) { String }
        let(:value) { 'some string' }
        
        it 'just returns the provided value' do
          subject.send(:parse_type, value, type).should eql(value)
        end
      end
    end
    
    describe '#parse_integer' do
      let(:value) { '1' }
      
      it 'returns the corresponding Integer object' do
        subject.send(:parse_integer, value).should eql(1)
      end
    end
    
    describe '#parse_float' do
      let(:value) { '0.1' }
      
      it 'returns the corresponding Float object' do
        subject.send(:parse_float, value).should eql(0.1)
      end
    end
    
    describe '#parse_date' do
      let(:parsed_date) { subject.send(:parse_date, value) }
      
      context 'when the value is nil' do
        let(:value) { nil }
      
        it 'returns a Date object corresponding to 2030-12-31' do
          parsed_date.should == Date.new(2030, 12, 31)
        end
      end
    
      context 'when the value contains only the year' do
        let(:value) { '1995' }
      
        it 'returns a Date object corresponding to the last day of the year' do
          parsed_date.should == Date.new(1995, 12, 31)
        end
      end
    
      context 'when the value contains only the year and the month' do
        let(:value) { '1995-04' }
      
        it 'returns a Date object corresponding to the last day of the month' do
          parsed_date.should == Date.new(1995, 4, 30)
        end
      end
    
      context 'when the value contains the year, month and day' do
        let(:value) { '1995-04-30' }
      
        it 'returns the corresponding Date object' do
          parsed_date.should == Date.new(1995, 4, 30)
        end
      end
    end

  end
end