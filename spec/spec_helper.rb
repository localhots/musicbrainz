require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require "vcr"
require "musicbrainz"

# HTTPI.log = false
Dir[File.dirname(__FILE__)+"/../lib/*.rb"].each{ |f| require f }
Dir[File.dirname(__FILE__)+"/../spec/support/*.rb"].each{ |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
end