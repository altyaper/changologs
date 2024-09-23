class Log < ApplicationRecord
  include Friendlyable
  
  belongs_to :user
  belongs_to :board
  has_one :site, dependent: :destroy

  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  
  validates :title, presence: true, length: { minimum: 5 }

  def tag_list
    tags.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    self.tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
  end

  def self.search(search)
    search ? where('lower(title) LIKE ? OR lower(text) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%") : all
  end

  def publish!
    update(published: true)
  end
end
