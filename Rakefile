# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "musicbrainz"
  gem.homepage = "http://github.com/magnolia-fan/musicbrainz"
  gem.license = "MIT"
  gem.summary = %Q{MusicBrainz Web Service wrapper}
  gem.description = %Q{MusicBrainz Web Service wrapper with ActiveRecord-style models}
  gem.email = "magnolia_fan@me.com"
  gem.authors = ["Gregory Eremin"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |test|
  test.verbose = true
end

desc "Run Test Unit with code coverage"
task :test_coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task["test"].execute
end

desc "Run RSpec with code coverage"
task :rspec_coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task["spec"].execute
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "musicbrainz #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
