class League < ActiveRecord::Base

  has_many :league_users
  has_many :users, :through => :league_users
  has_many :games

  mount_uploader :picture, PictureUploader

  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"

  def feed_items
    feed_items = Array.new
    games = self.games
    games.each do |game|
      feed_items += game.userposts
    end
    feed_items
  end

  def is_admin(user)
    #TODO improve the admin search
    self.league_users.where(user_id: user.id).first.admin
  end

end
