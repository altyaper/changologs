class AddBluriedToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :bluried, :boolean, :default => false
  end
end
