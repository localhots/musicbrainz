# encoding: utf-8

require "ostruct"
require "spec_helper"

describe MusicBrainz::Tools::Cache do
  before(:all) do
    @old_cache_path = MusicBrainz::Tools::Cache.cache_path
    @tmp_cache_path = File.join(File.dirname(__FILE__), "../../tmp/cache/test")
    @test_mbid = "69b39eab-6577-46a4-a9f5-817839092033"
    @test_cache_file = "#{@tmp_cache_path}/03/48/ec6c2bee685d9a96f95ed46378f624714e7a4650b0d44c1a8eee5bac2480.xml"
  end

  after(:all) do
    MusicBrainz.config.cache_path = @old_cache_path
  end

  before(:each) do
    file_path = File.join(File.dirname(__FILE__), "../fixtures/kasabian.xml")
    @test_response = File.open(file_path).read
  end

  context "with cache enabled" do
    it "calls http only once when requesting the resource twice" do
      MusicBrainz.config.cache_path = @tmp_cache_path
      File.exist?(@test_cache_file).should be_false

      # Stubbing
      MusicBrainz::Client.http.stub(:get).and_return(OpenStruct.new(status: 200, body: @test_response))
      MusicBrainz::Client.http.should_receive(:get).once

      2.times do
        artist = MusicBrainz::Artist.find(@test_mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        File.exist?(@test_cache_file).should be_true
      end

      MusicBrainz::Client.clear_cache
    end
  end

  context "with cache disabled" do
    it "calls http twice when requesting the resource twice" do
      MusicBrainz.config.perform_caching = false
      File.exist?(@test_cache_file).should be_false

      # Hacking for test performance purposes
      MusicBrainz.config.query_interval = 0.0

      # Stubbing
      MusicBrainz::Client.http.stub(:get).and_return(OpenStruct.new(status: 200, body: @test_response))
      MusicBrainz::Client.http.should_receive(:get).twice

      2.times do
        artist = MusicBrainz::Artist.find(@test_mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        File.exist?(@test_cache_file).should be_false
      end

      MusicBrainz.config.perform_caching = true
      MusicBrainz.config.query_interval = 1.5
    end
  end
end
