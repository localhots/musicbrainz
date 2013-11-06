# -*- encoding: utf-8 -*-

require "spec_helper"

describe MusicBrainz::Recording do
	describe '.find' do
		it "gets no exception while loading release info" do
			lambda {
				MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
			}.should_not raise_error(Exception)
		end

		it "gets correct instance" do
			track = MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
			track.should be_an_instance_of(MusicBrainz::Recording)
		end

		it "gets correct track data" do
			track = MusicBrainz::Recording.find("b3015bab-1540-4d4e-9f30-14872a1525f7")
			track.title.should == "Empire"
		end
	end

  describe '.search' do
		it "searches tracks (aka recordings) by artist name and title" do
			matches = MusicBrainz::Recording.search('Bound for the floor', 'Local H')
			matches.length.should be > 0
			matches.first[:title].should == "Bound for the Floor"
			matches.first[:artist].should == "Local H"
		end
	end
end
