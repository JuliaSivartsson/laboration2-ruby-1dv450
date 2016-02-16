class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :restaurants, :tags do |t|
       t.index [:restaurant_id, :tag_id]
       t.index [:tag_id, :restaurant_id]
    end
  end
end
