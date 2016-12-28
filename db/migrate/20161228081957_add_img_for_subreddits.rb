class AddImgForSubreddits < ActiveRecord::Migration
  def change
    add_column :subreddits, :image_url, :string
  end
end
