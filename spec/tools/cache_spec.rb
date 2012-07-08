require "spec_helper"

describe MusicBrainz::Tools::Cache do
  before(:all) do
    @old_cache_path = MusicBrainz::Tools::Cache.cache_path
    @tmp_cache_path = File.join(File.dirname(__FILE__), '../../tmp/cache/tools')
  end

  after(:all) do
    MusicBrainz::Tools::Cache.cache_path = @old_cache_path
  end

  before(:each) do
    file_path = File.join(File.dirname(__FILE__), "../fixtures/kasabian.xml")
    @test_response = ::StringIO.new(File.open(file_path).gets)
  end

  context "with cache enabled" do
    it "calls get contents only once when requesting the resource twice" do
      MusicBrainz::Tools::Cache.cache_path = @tmp_cache_path
      mbid = "69b39eab-6577-46a4-a9f5-817839092033"

      MusicBrainz::Tools::Proxy.stub(:get_contents).and_return(@test_response)
      MusicBrainz::Tools::Proxy.should_receive(:get_contents).once

      File.exist?("#{@tmp_cache_path}/artist/#{mbid}?inc=url-rels").should be_false
      artist = MusicBrainz::Artist.find(mbid)
      artist.should be_a_kind_of(MusicBrainz::Artist)

      File.exist?("#{@tmp_cache_path}/artist/#{mbid}?inc=url-rels").should be_true
      artist = MusicBrainz::Artist.find(mbid)
      artist.should be_a_kind_of(MusicBrainz::Artist)

      MusicBrainz::Tools::Cache.clear_cache
    end
  end

  context "with cache disabled" do
    it "calls get contents twice when requesting the resource twice" do
      MusicBrainz::Tools::Cache.cache_path = nil
      mbid = "69b39eab-6577-46a4-a9f5-817839092033"

      MusicBrainz::Tools::Proxy.stub(:get_contents).and_return(@test_response)
      MusicBrainz::Tools::Proxy.should_receive(:get_contents).twice

      File.exist?("#{@tmp_cache_path}/artist/#{mbid}?inc=url-rels").should be_false
      artist = MusicBrainz::Artist.find(mbid)
      artist.should be_a_kind_of(MusicBrainz::Artist)

      File.exist?("#{@tmp_cache_path}/artist/#{mbid}?inc=url-rels").should be_false
      @test_response.rewind
      MusicBrainz.stub(:get_contents).and_return(@test_response)
      artist = MusicBrainz::Artist.find(mbid)
      artist.should be_a_kind_of(MusicBrainz::Artist)
    end
  end
end
