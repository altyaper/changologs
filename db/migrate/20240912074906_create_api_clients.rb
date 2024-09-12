class CreateApiClients < ActiveRecord::Migration[7.1]
  def change
    create_table :api_clients do |t|
      t.string :client_id
      t.string :client_secret
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
