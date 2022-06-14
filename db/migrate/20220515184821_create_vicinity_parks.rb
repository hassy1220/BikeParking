class CreateVicinityParks < ActiveRecord::Migration[6.1]
  def change
    create_table :vicinity_parks do |t|
      t.integer :park_id,null: false
      t.integer :vicinity_id,null: false
      t.timestamps
    end
  end
end
