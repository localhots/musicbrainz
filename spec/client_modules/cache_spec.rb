# encoding: utf-8

require "ostruct"
require "spec_helper"

describe MusicBrainz::ClientModules::CachingProxy do
  def old_cache_path; File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'spec_cache'); end
  def tmp_cache_path; File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache_module_spec_cache'); end
  let(:test_mbid){ "69b39eab-6577-46a4-a9f5-817839092033" }
  let(:test_cache_file){ "#{tmp_cache_path}/03/48/ec/6c2bee685d9a96f95ed46378f624714e7a4650b0d44c1a8eee5bac2480.xml" }
  let(:test_cache_file_without_hexdigest_url){"#{tmp_cache_path}/artist/69b39eab-6577-46a4-a9f5-817839092033/inc=url-rels.xml"}
  let(:test_response_file){ File.join(File.dirname(__FILE__), "../fixtures/kasabian.xml") }
  let(:test_response){ File.open(test_response_file).read }

  before(:all) do
    MusicBrainz.config.cache_path = tmp_cache_path
  end

  after(:all) do
    MusicBrainz.config.cache_path = old_cache_path
    MusicBrainz.config.perform_caching = true
    MusicBrainz.config.query_interval = 1.5
    MusicBrainz.config.hexdigest_url = false
  end

  context "with cache enabled" do
    it "calls http only once when requesting the resource twice" do
      MusicBrainz.config.perform_caching = true
      
      { 
        test_cache_file => true,
        test_cache_file_without_hexdigest_url => false
      }.each do |cache_file,hexdigest_url|
        MusicBrainz.config.hexdigest_url = hexdigest_url
        
        expect(File.exist?(cache_file)).to be_falsey
  
        # Stubbing
        allow(MusicBrainz.client.http).to receive(:get).and_return(OpenStruct.new(status: 200, body: test_response))
        expect(MusicBrainz.client.http).to receive(:get).once
  
        2.times do
          artist = MusicBrainz::Artist.find(test_mbid)
          expect(artist.is_a?(MusicBrainz::Artist)).to be_truthy
          expect(File.exist?(cache_file)).to be_truthy
        end
  
        MusicBrainz.client.clear_cache
      end
    end
  end

  context "with cache disabled" do
    it "calls http twice when requesting the resource twice" do
      MusicBrainz.config.perform_caching = false
      expect(File.exist?(test_cache_file)).to be_falsey

      # Hacking for test performance purposes
      MusicBrainz.config.query_interval = 0.0

      # Stubbing
      allow(MusicBrainz.client.http).to receive(:get).and_return(OpenStruct.new(status: 200, body: test_response))
      expect(MusicBrainz.client.http).to receive(:get).twice

      2.times do
        artist = MusicBrainz::Artist.find(test_mbid)
        expect(artist.is_a?(MusicBrainz::Artist)).to be_truthy
        expect(File.exist?(test_cache_file)).to be_falsey
      end
    end
  end
end
