class Board < ApplicationRecord
  include Friendlyable

  enum board_type: { general: 0, daily_log: 1 }

  belongs_to :user
  has_many :logs, dependent: :delete_all
  has_many :user_boards, dependent: :delete_all

  def owner?(current_user)
    current_user.id == self.user_id
  end

  def logs_label
    logs_size = self.logs.size
    case logs_size
    when 0 then "empty"
    when 1 then "one log"
    else "#{logs_size} logs"
    end
  end
end
