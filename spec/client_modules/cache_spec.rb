# encoding: utf-8

require "ostruct"
require "spec_helper"

describe MusicBrainz::ClientModules::CachingProxy do
  let(:old_cache_path){ File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'spec_cache') }
  let(:tmp_cache_path){ File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache_module_spec_cache') }
  let(:test_mbid){ "69b39eab-6577-46a4-a9f5-817839092033" }
  let(:test_cache_file){ "#{tmp_cache_path}/03/48/ec/6c2bee685d9a96f95ed46378f624714e7a4650b0d44c1a8eee5bac2480.xml" }
  let(:test_response_file){ File.join(File.dirname(__FILE__), "../fixtures/kasabian.xml") }
  let(:test_response){ File.open(test_response_file).read }

  before(:all) do
    MusicBrainz.config.cache_path = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache_module_spec_cache')
  end

  after(:all) do
    MusicBrainz.config.cache_path = old_cache_path
    MusicBrainz.config.perform_caching = true
    MusicBrainz.config.query_interval = 1.5
  end

  context "with cache enabled" do
    it "calls http only once when requesting the resource twice" do
      MusicBrainz.config.perform_caching = true
      File.exist?(test_cache_file).should be_false

      # Stubbing
      MusicBrainz.client.http.stub(:get).and_return(OpenStruct.new(status: 200, body: test_response))
      MusicBrainz.client.http.should_receive(:get).once

      2.times do
        artist = MusicBrainz::Artist.find(test_mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        File.exist?(test_cache_file).should be_true
      end

      MusicBrainz.client.clear_cache
    end
  end

  context "with cache disabled" do
    it "calls http twice when requesting the resource twice" do
      MusicBrainz.config.perform_caching = false
      File.exist?(test_cache_file).should be_false

      # Hacking for test performance purposes
      MusicBrainz.config.query_interval = 0.0

      # Stubbing
      MusicBrainz.client.http.stub(:get).and_return(OpenStruct.new(status: 200, body: test_response))
      MusicBrainz.client.http.should_receive(:get).twice

      2.times do
        artist = MusicBrainz::Artist.find(test_mbid)
        artist.should be_a_kind_of(MusicBrainz::Artist)
        File.exist?(test_cache_file).should be_false
      end
    end
  end
end
