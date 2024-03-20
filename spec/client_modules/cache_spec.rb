require "ostruct"
require "spec_helper"

describe MusicBrainz::ClientModules::CachingProxy do
  let(:test_mbid){ "69b39eab-6577-46a4-a9f5-817839092033" }
  let(:tmp_cache_path){ File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache_module_spec_cache') }
  let(:test_cache_file){ "#{tmp_cache_path}/03/48/ec/6c2bee685d9a96f95ed46378f624714e7a4650b0d44c1a8eee5bac2480.xml" }
  let(:test_response){ read_fixture('artist/find_69b39eab-6577-46a4-a9f5-817839092033.xml') }

  before(:all) do
    MusicBrainz.config.cache_path = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache_module_spec_cache')
  end

  before do
    File.delete(test_cache_file) if File.exist?(test_cache_file)
  end

  after(:all) do
    MusicBrainz.config.cache_path = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'spec_cache')
    MusicBrainz.config.perform_caching = true
    MusicBrainz.config.query_interval = 1.5
  end

  context "with cache enabled" do
    it "calls http only once when requesting the resource twice" do
      MusicBrainz.config.perform_caching = true
      expect(File).to_not exist(test_cache_file)

      # Stubbing
      allow(MusicBrainz.client).to receive(:get_live_contents)
        .and_return({status: 200, body: test_response})
      expect(MusicBrainz.client).to receive(:get_live_contents).once

      2.times do
        artist = MusicBrainz::Artist.find(test_mbid)
        expect(artist).to be_kind_of(MusicBrainz::Artist)
        expect(File).to exist(test_cache_file)
      end

      MusicBrainz.client.clear_cache
    end
  end

  context "with cache disabled" do
    it "calls http twice when requesting the resource twice" do
      MusicBrainz.config.perform_caching = false
      expect(File).to_not exist(test_cache_file)

      # Hacking for test performance purposes
      MusicBrainz.config.query_interval = 0.0

      # Stubbing
      allow(MusicBrainz.client.http).to receive(:get).and_return(OpenStruct.new(status: 200, body: test_response))
      expect(MusicBrainz.client.http).to receive(:get).twice

      2.times do
        artist = MusicBrainz::Artist.find(test_mbid)
        expect(artist).to be_kind_of(MusicBrainz::Artist)
        expect(File).to_not exist(test_cache_file)
      end
    end
  end
end
