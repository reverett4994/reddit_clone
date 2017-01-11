class Post < ActiveRecord::Base
  self.per_page = 10
  acts_as_votable
  acts_as_commentable
  belongs_to :user
  belongs_to :subreddit
  validates :title, length: { in: 2..250 }
end
