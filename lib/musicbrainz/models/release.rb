module MusicBrainz
  class Release < BaseModel
    include Mapper::Resources::Release
    
    attr_accessor :tracks
    
    # user_tags user_ratings
    INCLUDES = %w(artists labels recordings release_groups recording_level_rels work_level_rels discids media puids isrcs artist_credits annotation url_rels artist_rels label_rels recording_rels release_rels release_group_rels url_rels work_rels collections)
    
    def tracks
      return if @id.nil? || do_not_search
      
      @tracks ||= association(:tracks, [:recordings, :media], :position)
    end

    class << self
      def find(id, standard_includes = nil)
        super(id, standard_includes || [:media, :release_groups, :url_rels])
      end
      
      def find_by_release_group_id(release_group_id, query = {})
        ReleaseGroup.new(id: release_group_id).releases(query)
      end
    end
  end
end
