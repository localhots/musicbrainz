# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz do
  before(:all) {
    @old_cache_path = MusicBrainz.config.cache_path
    @old_query_interval = MusicBrainz.config.query_interval
  }

  before(:each) {
    MusicBrainz.config.cache_path = nil
    MusicBrainz.config.query_interval = nil
  }

  after(:all) {
    MusicBrainz.config.cache_path = @old_cache_path
    MusicBrainz.config.query_interval = @old_query_interval
  }

  it "allows deprecated use of cache_path" do
    MusicBrainz.config.cache_path = "test1"

    MusicBrainz::Tools::Cache.cache_path.should == "test1"
    MusicBrainz.cache_path.should == "test1"
  end

  it "allows deprecated use of cache_path=" do
    MusicBrainz::Tools::Cache.cache_path = "test2"
    MusicBrainz.config.cache_path.should == "test2"

    MusicBrainz.cache_path = "test3"
    MusicBrainz.config.cache_path.should == "test3"
  end

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
