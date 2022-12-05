class RemoveDogsUniqueOwnerConstraint < ActiveRecord::Migration[5.2]
  def change
    remove_index :dogs, :owner_id
    add_index :dogs, :owner_id
  end
end
