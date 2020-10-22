class Post < ApplicationRecord
  belongs_to :user

  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }
end
