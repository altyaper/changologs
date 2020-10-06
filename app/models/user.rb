class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :logs
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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

  has_many :user_boards

  scope :search, -> (search, id) {
    where('lower(email) LIKE ? AND id != ?', "%#{search.downcase}%", id)
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def friendships
    self.friendships_as_friend_a + self.friendships_as_friend_b
  end

end
