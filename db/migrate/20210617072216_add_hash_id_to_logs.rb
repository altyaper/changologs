class AddHashIdToLogs < ActiveRecord::Migration[5.2]
  def up
    add_column :logs, :hash_id, :string, index: true
    Log.all.each{|m| m.set_hash_id; m.save}
  end

  def down
    remove_column :logs, :hash_id, :string
  end
end
