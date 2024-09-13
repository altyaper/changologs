class User < ApplicationRecord
  devise :two_factor_authenticatable
  include ActiveModel::Serialization
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :logs
  has_many :api_clients
  has_many :user_boards  
  has_one_attached :profile_picture

  has_many :friend_requests_as_requestor,
    foreign_key: :requestor_id,
    class_name: :FriendRequest

  has_many :friend_requests_as_receiver,
    foreign_key: :receiver_id,
    class_name: :FriendRequest

  has_many :friendships_as_friend_a, 
    foreign_key: :friend_a_id, 
    class_name: :Friendship

  has_many :friendships_as_friend_b, 
      foreign_key: :friend_b_id, 
      class_name: :Friendship
  
  has_many :friend_as, through: :friendships_as_friend_b

  has_many :friend_bs, through: :friendships_as_friend_a


  scope :search, -> (search, id) {
    where('lower(email) LIKE ? AND id != ?', "%#{search.downcase}%", id)
  }

  def profile_picture_url
    profile_picture.attached? ? rails_blob_path(profile_picture, only_path: true) : nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def friendships
    self.friendships_as_friend_a + self.friendships_as_friend_b
  end
end
