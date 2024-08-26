class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActiveStorage::Blob::Analyzable

  attributes :id, :email, :profile_picture, :first_name, :last_name

  def profile_picture
    object.profile_picture.attached? ? rails_blob_path(object.profile_picture, only_path: true) : nil
  end
end
