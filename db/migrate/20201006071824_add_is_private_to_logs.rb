class AddIsPrivateToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :is_private, :boolean, :default => false
  end
end
