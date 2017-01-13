class RenamePasswordColumn < ActiveRecord::Migration
  def change
    rename_column :subreddits, :password_hash, :password_digest
  end
end
