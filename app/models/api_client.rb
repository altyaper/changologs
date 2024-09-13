class ApiClient < ApplicationRecord
  before_create :generate_credentials
  belongs_to :user

  validates :name, presence: true

  def generate_credentials
    self.client_id = SecureRandom.hex(16)
    self.client_secret = SecureRandom.hex(32)
  end
end
