class AddPublishedToLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :logs, :published, :boolean
  end
end
