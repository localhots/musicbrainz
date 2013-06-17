module MusicBrainz
  class Work < BaseModel
    include Mapper::Resources::Work
    
    # user_tags user_ratings
    INCLUDES = %w(aliases tags ratings annotation url_rels artist_rels label_rels recording_rels release_rels release_group_rels url_rels work_rels)
    
    class << self
    end
  end
end
