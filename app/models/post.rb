class Post < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  belongs_to :subreddit
  validates :title, length: { in: 2..250 }
end
