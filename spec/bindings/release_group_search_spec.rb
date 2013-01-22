# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Bindings::ReleaseGroupSearch do
  describe '.parse' do
    it "gets correct release group data" do
      response = '<release-group-list><release-group id="246bc928-2dc8-35ba-80ee-7a0079de1632" type="Single" ext:score="100"><title>Empire</title></release-group>'
      described_class.parse(Nokogiri::XML.parse(response)).should == [
        {
          id: '246bc928-2dc8-35ba-80ee-7a0079de1632', mbid: '246bc928-2dc8-35ba-80ee-7a0079de1632', 
          title: 'Empire', type: 'Single', score: 100
        }
      ]
    end
  end
end