class User < ActiveRecord::Base
  has_one  :photo, as: :picture, dependent: :destroy
  accepts_nested_attributes_for :photo
  has_many :userposts, dependent: :destroy
  has_many :scores
  has_many :games, :through => :scores
  has_many :event_votes
  has_many :game_events
  has_many :league_users
  has_many :leagues, :through => :league_users
  has_many :friendships
  has_many :friends,
           -> {where "friendships.status = 'accepted'"},
           :through => :friendships,
           source: :friend

  has_many :requested_friends,
           -> {where "friendships.status = 'requested'"},
           through: :friendships,
           source: :friend

  has_many :pending_friends,
           -> {where "friendships.status = 'pending'"},
           through: :friendships,
           source: :friend

  before_create :create_remember_token
  before_save { self.email = email.downcase }


  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  def open_votes
    self.event_votes.where(has_voted: false)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
