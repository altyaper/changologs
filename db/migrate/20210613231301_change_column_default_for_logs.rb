class ChangeColumnDefaultForLogs < ActiveRecord::Migration[5.2]
  def change
    change_column :logs, :is_private, :boolean, :default => true
  end
end
