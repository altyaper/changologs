class RemovePhotoToUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :photo, :string
  end
end
