module MockHelpers
	def mock(url:, fixture:)
    allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
      .with(url)
      .and_return({ status: 200, body: read_fixture(fixture)})
	end

	def read_fixture(name)
		spec_path = File.join(File.dirname(__FILE__), "..")
		file_path = File.join(spec_path, "fixtures", name)
		File.open(file_path).read
	end
end
