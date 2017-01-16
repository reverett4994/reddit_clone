class Subreddit < ActiveRecord::Base
  has_secure_password

  self.per_page = 10
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :posts
  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :admins, :uniq => true
  scope :default, -> { where(frontpage: true) }
  validates :name, :slug,:description, presence: true
  before_save :set_rules
  before_save :set_message


  def set_rules
    if self.rules==""
      self.rules="No Rules Have Been Set by The Mod(s)!!!"
    end
  end

  def set_message
    if self.message==""
      self.message="No Message Have Been Left by The Mod(s)!!! :("
    end
  end
end
