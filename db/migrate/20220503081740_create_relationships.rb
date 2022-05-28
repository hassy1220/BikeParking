class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follow_id
      t.integer :follower_id
      t.timestamps
      t.index [:follow_id, :follower_id], unique: true
    end
  end
end
