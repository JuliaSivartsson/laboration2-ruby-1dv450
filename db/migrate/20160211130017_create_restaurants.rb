class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|

      t.string :name
      t.string :message
      t.integer :rating
      t.belongs_to :position, index: true
      t.timestamps null: false
    end
  end
end
