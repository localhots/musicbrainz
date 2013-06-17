module MusicBrainz
  class Medium < BaseModel
    include Mapper::Resources::Medium
    
    def tracks_count
      tracks.respond_to?(:total_count) ? tracks.total_count : 0
    end
  end
end
