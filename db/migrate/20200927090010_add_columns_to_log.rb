class AddColumnsToLog < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :color, :string
  end
end
