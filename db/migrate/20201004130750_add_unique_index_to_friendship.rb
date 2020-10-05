class AddUniqueIndexToFriendship < ActiveRecord::Migration[5.2]
  def change
    add_index :friendships, [:friend_a_id, :friend_b_id], unique: true
  end
end
