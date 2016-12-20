class AddSubredditIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :subreddit_id, :string
  end
end
