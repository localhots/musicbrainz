# -*- encoding: utf-8 -*-

module MusicBrainz
  module Parsers
    class Artist < Base
      class << self
        def model(xml)
          res = {
            :id => safe_get_attr(xml, "artist", "id"),
            :type => safe_get_attr(xml, "artist", "type"),
            :name => safe_get_value(xml, "artist > name").gsub(/[`’]/, "'"),
            :country => safe_get_value(xml, "artist > country"),
            :date_begin => safe_get_value(xml, "artist > life-span > begin"),
            :date_end => safe_get_value(xml, "artist > life-span > end"),
            :urls => {}
          }
          xml.css("relation-list[target-type='url'] > relation").each { |rel|
            res[:urls][rel.attr("type").downcase.split(" ").join("_").to_sym] = rel.css("target").text
          }
          res
        end

        def search(xml)
          artists = []
          xml.css("artist-list > artist").each do |a|
            artists << {
              :name => a.first_element_child.text.gsub(/[`’]/, "'"),
              :sort_name => safe_get_value(a, "sort-name").gsub(/[`’]/, "'"),
              :weight => 0,
              :desc => safe_get_value(a, "disambiguation"),
              :type => safe_get_attr(a, nil, "type"),
              :mbid => safe_get_attr(a, nil, "id"),
              :aliases => a.css("alias-list > alias").map { |item| item.text }
            }
          end
          artists
        end

        def release_groups(xml)
          release_groups = []
          xml.css("release-group").each do |rg|
            release_groups << MusicBrainz::Parsers::ReleaseGroup.model(rg)
          end
          release_groups
        end
      end
    end
  end
end
