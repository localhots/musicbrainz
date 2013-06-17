module MusicBrainz
  class Label < BaseModel
    include Mapper::Resources::Label
    
    # user_tags user_ratings
    INCLUDES = %w(releases aliases tags ratings discids media artist_credits annotation url_rels artist_rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)
    
    class << self
    end
  end
end
