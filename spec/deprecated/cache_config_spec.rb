# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Deprecated::CacheConfig do
  before(:all) {
    @old_cache_path = MusicBrainz.config.cache_path
  }

  before(:each) {
    MusicBrainz.config.cache_path = nil
  }

  after(:all) {
    MusicBrainz.config.cache_path = @old_cache_path
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
end
