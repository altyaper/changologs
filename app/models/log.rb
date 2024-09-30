class Log < ApplicationRecord
  include Friendlyable

  before_save :analyze_sentiment
  
  belongs_to :user
  belongs_to :board

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

  private

  def analyze_sentiment
    analyzer = Sentimental.new
    analyzer.load_defaults
    score = analyzer.score(self.text)
    if score > 0.1
      self.sentiment = 'positive'
    elsif score < -0.1
      self.sentiment = 'negative'
    else
      self.sentiment = 'neutral'
    end
  end

end
