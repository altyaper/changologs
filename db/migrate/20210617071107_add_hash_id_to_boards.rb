class AddHashIdToBoards < ActiveRecord::Migration[5.2]
  def up
    add_column :boards, :hash_id, :string, index: true
    Board.all.each{|m| m.set_hash_id; m.save}
  end

  def down
    remove_column :boards, :hash_id, :string
  end
end
