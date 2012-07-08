# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz do
  before(:all) {
    @old_cache_path = MusicBrainz::Tools::Cache.cache_path
  }

  before(:each) {
    $stdout.stub!(:puts)
    MusicBrainz::Tools::Cache.cache_path = nil
  }

  after(:all) {
    MusicBrainz::Tools::Cache.cache_path = @old_cache_path
  }

  it "allows deprecated use of cache_path" do
    MusicBrainz::Tools::Cache.cache_path = "some/path"
    MusicBrainz::cache_path.should == "some/path"
  end

  it "allows deprecated use of cache_path=" do
    MusicBrainz.cache_path = "some/path"
    MusicBrainz::Tools::Cache.cache_path.should == "some/path"
  end

  it "allows deprecated use of query_interval" do
    MusicBrainz::Tools::Proxy.query_interval = 2
    MusicBrainz::query_interval.should == 2
  end

  it "allows deprecated use of query_interval=" do
    MusicBrainz.query_interval = 2
    MusicBrainz::Tools::Proxy.query_interval.should == 2
  end
end
