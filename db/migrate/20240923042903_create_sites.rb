class CreateSites < ActiveRecord::Migration[7.1]
  def change
    create_table :sites do |t|
      t.string :subdomain
      t.string :name
      t.references :log, null: false, foreign_key: true

      t.timestamps
    end
  end
end
