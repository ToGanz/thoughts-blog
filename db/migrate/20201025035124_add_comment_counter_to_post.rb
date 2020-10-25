class AddCommentCounterToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :total_comments_count, :integer, default: 0
  end
end
