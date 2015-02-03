# -*- encoding: utf-8 -*-

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

    expect(MusicBrainz::Tools::Proxy.query_interval).to be == 2
    expect(MusicBrainz.query_interval).to be == 2
  end

  it "allows deprecated use of query_interval=" do
    MusicBrainz::Tools::Proxy.query_interval = 3
    expect(MusicBrainz.config.query_interval).to be == 3

    MusicBrainz.query_interval = 4
    expect(MusicBrainz.config.query_interval).to be == 4
  end
end
