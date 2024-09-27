class Site < ApplicationRecord
  belongs_to :log
  belongs_to :user
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
end
