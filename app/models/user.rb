class User < ActiveRecord::Base
  # has_and_belongs_to_many :games,
  has_many :userposts, dependent: :destroy
  has_many :scores
  has_many :games, :through => :scores
  has_many :event_votes
  has_many :game_events
  has_many :league_users
  has_many :leagues, :through => :league_users
  has_many :friendships
  has_many :friends, :through => :friendships

  mount_uploader :picture, PictureUploader


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
    self.event_votes.where(has_voted: false).count
  end

  def open_votes_by_game game
    self.event_votes.where(game_id: game.id, has_voted: false).count
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
