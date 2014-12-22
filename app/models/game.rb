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
    @rank = Game.find_by_sql("SELECT COUNT(*) AS rank FROM scores WHERE points >= (SELECT Points FROM scores WHERE game_id = :game_id and user_id = :user_id)", {game_id: self.id, user_id: user.id}  )
    @rank = Game.find_by_sql("SELECT COUNT(*) AS ranking FROM scores WHERE points > (SELECT Points FROM scores WHERE game_id = :game_id and user_id = :user_id)", {game_id: self.id, user_id: user.id}  )

    @rank[0].ranking

    # #TODO position rank query is broken.
    # @rank = Game.find_by_sql("SELECT COUNT(*) AS rank FROM scores WHERE points >= (SELECT Points FROM scores WHERE game_id = :game_id )", {game_id: self.id} )
    # "#{@rank[0].rank}/#{self.users.count}"
    #
    # SELECT a1.user_id, a1.points, COUNT (a2.points) user_Rank
    # FROM scores a1, scores a2
    # WHERE a1.points <= a2.points OR (a1.points=a2.points AND a1.user_id = a2.user_id)
    # GROUP BY a1.user_id, a1.points
    # ORDER BY a1.points DESC, a1.user_id DESC;

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

end
