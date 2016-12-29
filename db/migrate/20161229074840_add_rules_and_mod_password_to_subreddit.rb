class AddRulesAndModPasswordToSubreddit < ActiveRecord::Migration
  def change
    add_column :subreddits, :rules, :text
    add_column :subreddits, :message, :text
    add_column :subreddits, :password_hash, :string
  end
end
