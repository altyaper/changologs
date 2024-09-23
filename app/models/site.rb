class Site < ApplicationRecord
  belongs_to :log
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
end
