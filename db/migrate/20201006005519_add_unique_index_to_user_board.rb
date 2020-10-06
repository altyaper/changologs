class AddUniqueIndexToUserBoard < ActiveRecord::Migration[5.2]
  def change
    add_index :user_boards, [:user_id, :board_id], unique: true
  end
end
