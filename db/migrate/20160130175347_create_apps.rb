class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|

      t.string :name
      t.string :description
      t.string :apikey
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
