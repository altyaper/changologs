class Board < ApplicationRecord
  belongs_to :user
  has_many :logs, dependent: :delete_all
  has_many :user_boards

  def owner?(current_user)
    current_user.id == self.user_id
  end
end
