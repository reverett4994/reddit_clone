require 'bcrypt'
class Subreddit < ActiveRecord::Base
  self.per_page = 10
  extend FriendlyId
  friendly_id :name, use: :slugged
  include BCrypt
  has_many :posts
  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :admins, :uniq => true
  scope :default, -> { where(frontpage: true) }

  before_save :set_rules
  before_save :set_message
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

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
