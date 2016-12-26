class AddFrontpageDefaultSubreddits < ActiveRecord::Migration
  def change
    add_column :subreddits, :frontpage, :boolean, :default=>false
  end
end
