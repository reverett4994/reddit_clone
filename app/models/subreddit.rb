class Subreddit < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :posts
  has_and_belongs_to_many :users, :uniq => true
end
