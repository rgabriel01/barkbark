class CreateLikesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :dog_id
      t.integer :user_id
      t.timestamps
    end

    add_index :likes, [:dog_id, :user_id]
  end
end
