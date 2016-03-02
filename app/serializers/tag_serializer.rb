class TagSerializer < ActiveModel::Serializer
    attributes :id, :name, :links
    
  def links
    {
        self: api_v1_tag_path(object.id),
        restaurants: api_v1_tag_restaurants_path(object.id)
    }
  end
end
