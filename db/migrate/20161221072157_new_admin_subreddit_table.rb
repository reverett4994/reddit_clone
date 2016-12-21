class NewAdminSubredditTable < ActiveRecord::Migration
  def change
    create_table :admins_subreddits, id: false do |t|
      t.belongs_to :admin, index: true
      t.belongs_to :subreddit, index: true
    end
  end
end
