VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'vcr')
  c.stub_with :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].gsub(/\s/, '_')
    VCR.use_cassette(name) { example.call }
  end
end