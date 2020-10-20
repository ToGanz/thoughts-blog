class FixPostColumnContent < ActiveRecord::Migration[6.0]
  def change
    def change
      rename_column :posts, :description, :content
    end
  end
end
