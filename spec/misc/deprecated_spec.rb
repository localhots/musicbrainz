require "spec_helper"

describe MusicBrainz do
  before(:each) {
    STDOUT.stub!(:puts)
  }

  after(:all) {
    MusicBrainz.cache_path.nil
  }

  it "allows deprecated use of cache_path" do
    MusicBrainz.cache_path = "some/path"
    MusicBrainz::Tools::Cache.cache_path.should == "some/path"
  end

  it "allows deprecated use of query_interval" do
    MusicBrainz.query_interval = 2
    MusicBrainz::Tools::Proxy.query_interval.should == 2
  end
end
