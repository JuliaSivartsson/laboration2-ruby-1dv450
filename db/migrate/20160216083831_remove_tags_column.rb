class RemoveTagsColumn < ActiveRecord::Migration
  def change
    remove_column :tags, :message
    remove_column :tags, :rating
    remove_column :tags, :restaurant_id
  end
end
