class AddDefaultToIsPrivateInBoards < ActiveRecord::Migration[7.1]
  def change
    change_column_default :boards, :is_private, from: nil, to: false
  end
end
