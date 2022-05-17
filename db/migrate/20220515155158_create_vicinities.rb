class CreateVicinities < ActiveRecord::Migration[6.1]
  def change
    create_table :vicinities do |t|
      t.string :vicinity_name, null: false
      t.timestamps
    end
  end
end
