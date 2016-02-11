class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|

      t.string :name
      t.string :description
      t.string :longitude
      t.string :latitude
      t.timestamps null: false
    end
  end
end
