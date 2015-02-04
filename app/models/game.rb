class Game < ActiveRecord::Base
  has_many :scores
  has_many :users, :through => :scores
  has_many :userposts
  has_many :game_events, dependent: :destroy
  has_many :ordered_scores, -> {order("points desc")}, class_name: "Score"
  has_many :active_game_events, -> { where(active: true)}, class_name: "GameEvent"
  belongs_to :league


  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"

  def leader
    self.scores.order('points desc').first
  end

  def points user
    score = self.scores.where(:user_id => user.id).first
    if score.nil?
      "N/A"
    else
      score.points
    end
  end

  def position user
    if self.users.include?(user)
      @rank = Score.find_by_sql ["select (select  count(*)+1 from scores as s2 where s2.points > s1.points and game_id = :game_id) as user_rank from scores as s1 WHERE game_id = :game_id and user_id = :user_id", {game_id: self.id, user_id: user.id}]
      @rank[0].user_rank
    else
      "N/A"
    end
  end

  def active_event_votes(current_user_id)
    @event_votes = Array.new
    game_events.active.each do |game_event|
      @event_votes += game_event.event_votes.where(user_id: current_user_id)
    end
    @event_votes
  end

  def inactive_event_votes(current_user_id)
    @event_votes = Array.new
    game_events.each do |game_event|
      @event_votes += game_event.event_votes.where(user_id: current_user_id)
    end
    @event_votes
  end

  def is_passing?

    if !self.score_cap.nil? && self.scores.maximum(:points) >= self.score_cap
      true
    else
      false
    end

  end

  def deactivate
    self.update_attribute(:active, false)
    Userpost.create_game_winner(game)
  end

end
