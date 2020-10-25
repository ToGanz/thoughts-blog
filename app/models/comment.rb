class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  default_scope -> { order(created_at: :asc) }

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, length: { minimum: 2, maximum: 300 }

  after_create :increase_post_comment_counter
  after_destroy :decrease_post_comment_counter
  
  private

  def increase_post_comment_counter
    Post.find(self.post_id).increment(:total_comments_count).save
  end

  def decrease_post_comment_counter
    Post.find(self.post_id).decrement(:total_comments_count).save
  end

end