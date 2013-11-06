# -*- encoding : utf-8 -*-

require "spec_helper"

describe MusicBrainz::Deprecated::ProxyConfig do
  before(:all) {
    @old_query_interval = MusicBrainz.config.query_interval
  }

  before(:each) {
    MusicBrainz.config.query_interval = nil
  }

  after(:all) {
    MusicBrainz.config.query_interval = @old_query_interval
  }

  it "allows deprecated use of query_interval" do
    MusicBrainz.config.query_interval = 2

    MusicBrainz::Tools::Proxy.query_interval.should == 2
    MusicBrainz.query_interval.should == 2
  end

  it "allows deprecated use of query_interval=" do
    MusicBrainz::Tools::Proxy.query_interval = 3
    MusicBrainz.config.query_interval.should == 3

    MusicBrainz.query_interval = 4
    MusicBrainz.config.query_interval.should == 4
  end
end
