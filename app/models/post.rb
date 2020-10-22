class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }
end
