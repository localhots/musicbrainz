module MusicBrainz
  class Recording < BaseModel
    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer

    class << self
      def find(id)
        client.load(:recording, { id: id }, {
          binding: :recording,
          create_model: :recording
        })
      end

			def search(hash)
				super(hash)
			end
    end
  end
end
