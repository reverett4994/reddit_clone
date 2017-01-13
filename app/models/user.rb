class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable
  acts_as_voter
  has_many :posts
  has_and_belongs_to_many :subreddits, :uniq => true
  has_one :admin
  validates :username, presence: true
  validates :username, length: { in: 2..25 }
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "please enter valid email" }
  after_create :create_admin
  after_create :send_welcome_mail
  before_destroy :destroy_admin
  before_destroy :send_goodbye_mail
  before_destroy {|object| object.subreddits.clear}
  def create_admin
    Admin.create :user_id => self.id
  end

  def send_welcome_mail
    UserMailer.welcome(self).deliver
  end

  def send_goodbye_mail
    UserMailer.goodbye(self).deliver
  end

  def destroy_admin
    self.admin.destroy
  end
end
