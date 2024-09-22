class AddTypeToBoards < ActiveRecord::Migration[7.1]
  def change
    add_column :boards, :board_type, :integer, default: 0
  end
end
