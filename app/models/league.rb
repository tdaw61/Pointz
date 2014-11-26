class League < ActiveRecord::Base
  #TODO still need league settings page with admin settings, picture upload, motto change.

  has_many :league_users
  has_many :users, :through => :league_users
  has_many :games

  accepts_nested_attributes_for :games

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
    #TODO decide if league admin
    true
  end

end
