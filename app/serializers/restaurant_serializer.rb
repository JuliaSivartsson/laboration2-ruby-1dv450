class RestaurantSerializer < ActiveModel::Serializer
    attributes :id, :name, :message, :rating, :links
    
    has_one :position, serializer: PositionSerializer
    has_many :tags, serializer: TagSerializer
    has_one :creator, serializer: CreatorSerializer
    #has_one :position, serializer: PositionSerializer

  def links
    {
        self: api_v1_restaurant_path(object.id),
        creator: api_v1_creator_path(object.creator.id),
        position: api_v1_restaurant_positions_path(object.id),
        tags: api_v1_restaurant_tags_path(object.id)
    }
  end
end
