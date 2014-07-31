class Game < ActiveRecord::Base
  has_many :scores
  has_many :users, :through => :scores
  has_many :userposts
  has_many :game_events, dependent: :destroy


  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"


  def belongs_to_game?(user_id)
      users.find(user_id)
  end

end
