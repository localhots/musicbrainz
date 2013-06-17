module MusicBrainz
  class Track < BaseModel
    include Mapper::Resources::Track
    
    xml_accessor :mbid, from: '@id' # deprecated
    
    # user_tags user_ratings
    INCLUDES = %w(artists releases artist_credits tags ratings annotation url_rels artist-rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)
    
    # delegations
    def artists; @artists || (recording.nil? ? nil : recording.artists); end
    def title; @title || (recording.nil? ? nil : recording.title); end
  end
end
