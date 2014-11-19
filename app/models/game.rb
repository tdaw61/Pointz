class Game < ActiveRecord::Base
  has_many :scores
  has_many :users, :through => :scores
  has_many :userposts
  has_many :game_events, dependent: :destroy
  belongs_to :league


  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"


  def belongs_to_game?(user_id)
      users.find(user_id)
  end

  def leader
    self.include("scores").where(maximum("points")).name
  end

  def ordered_scores
    scores.order('points DESC')
  end

  def points user
    self.scores.where(:user_id => user.id).first.points
  end

  def position user
    scores = self.scores
    scores.order(points: :desc).where(user_id: user.id)
  end

  def active_event_votes current_user_id
    @event_votes = Array.new
    game_events.where(active: true).each do |game_event|
      @event_votes += game_event.event_votes.where(user_id: current_user_id)
    end
    @event_votes
  end

end
