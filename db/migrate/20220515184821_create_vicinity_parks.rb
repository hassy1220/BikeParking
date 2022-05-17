class CreateVicinityParks < ActiveRecord::Migration[6.1]
  def change
    create_table :vicinity_parks do |t|
      t.integer :park_id
      t.integer :vicinity_id
      t.timestamps
    end
  end
end
