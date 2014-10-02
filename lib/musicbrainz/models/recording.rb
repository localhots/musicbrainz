module MusicBrainz
  class Recording < BaseModel
    field :position, Integer
    field :recording_id, String
    field :title, String
    field :length, Integer
    field :artist_credits, Array

    def full_artist_name
      @full_artist_name ||= artist_credits.inject('') do |mem, credit|
        mem << credit.xpath('./artist/name').text rescue ''
        mem << credit.attributes['joinphrase'].try(:value).to_s
        mem 
      end
    end

    class << self
      def find(id, args = {})
        client.load(:recording, { id: id }.merge(args), {
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
