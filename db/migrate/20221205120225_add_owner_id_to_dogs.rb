class AddOwnerIdToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :owner_id, :integer
    add_index :dogs, :owner_id, unique: true
  end
end
