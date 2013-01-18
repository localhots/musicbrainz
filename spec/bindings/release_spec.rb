# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Bindings::Release do
  describe '.parse' do
    describe 'attributes' do
      describe 'format' do
        context 'single cd' do
          it 'returns CD' do
            response = '<release><medium-list count="1"><medium><format>CD</format></medium></medium-list></release>'
            xml = Nokogiri::XML.parse(response)
            described_class.parse(xml)[:format].should == 'CD'
          end
        end
        
        context 'multiple cds' do
          it 'returns 2xCD' do
            response = '<release><medium-list count="2"><medium><format>CD</format><track-list count="11" /></medium><medium><title>bonus disc</title><format>CD</format></medium></medium-list></release>'
            xml = Nokogiri::XML.parse(response)
            described_class.parse(xml)[:format].should == '2xCD'
          end
        end
        
        context 'different formats' do
          it 'returns DVD + CD' do
            response = '<release><medium-list count="2"><medium><format>DVD</format></medium><medium><format>CD</format></medium></medium-list></release>'
            xml = Nokogiri::XML.parse(response)
            described_class.parse(xml)[:format].should == 'DVD + CD'
          end
        end
        
        context 'different formats plus multiple mediums with same format' do
          it 'returns 2xCD + DVD' do
            response = '<release><medium-list count="2"><medium><format>CD</format></medium><medium><format>CD</format></medium><medium><format>DVD</format></medium></medium-list></release>'
            xml = Nokogiri::XML.parse(response)
            described_class.parse(xml)[:format].should == '2xCD + DVD'
          end
        end
      end
    end
  end
end