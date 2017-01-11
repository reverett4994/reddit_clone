class AddOptionToTurnOffEmailsForNewComments < ActiveRecord::Migration
  def change
    add_column :users, :comment_emails, :boolean, :default=>true
  end
end
