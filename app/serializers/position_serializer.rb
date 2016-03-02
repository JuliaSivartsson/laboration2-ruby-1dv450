class PositionSerializer < ActiveModel::Serializer
    attributes :id, :address, :latitude, :longitude, :links
    
  def links
    {
        self: api_v1_position_path(object.id),
        restaurants: api_v1_position_restaurants_path(object.id)

    }
  end
end
