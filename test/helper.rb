require 'simplecov'

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter '/gems/'
    add_filter '/test/'
    add_filter '/spec/'
  end
end

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'musicbrainz'

class Test::Unit::TestCase
end
