class AddBoardsToLogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :logs, :board, foreign_key: true
  end
end
