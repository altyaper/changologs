class Board < ApplicationRecord
  belongs_to :user
  has_many :logs, dependent: :delete_all
end
