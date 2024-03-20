module MockHelpers
	def mock(url:, fixture:)
		spec_path = File.join(File.dirname(__FILE__), "..")
		file_path = File.join(spec_path, "fixtures", fixture)
		response = File.open(file_path).read

    allow_any_instance_of(MusicBrainz::Client).to receive(:get_contents)
      .with(url)
      .and_return({ status: 200, body: response})
	end
end
