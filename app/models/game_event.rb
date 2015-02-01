class GameEvent < ActiveRecord::Base
  #TODO add event expand option on click to table cell. should give date and more detail.
  belongs_to :game
  belongs_to :user
  belongs_to :target_user, class_name: "User"

  has_many :inactive_event_votes, -> {where(active: false)}, class_name: "EventVote"


  has_many :event_votes

  validates_presence_of :point_value, :target_user_id, :user_id, :game_id
  validates_presence_of :data, message: "reason can't be blank"
  validates_numericality_of :point_value

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }


  def has_passed?
    # this could potentially be very slow and cumbersome
    if (yes_votes.to_f / self.game.users.count.to_f).to_f > 0.5 || self.game.users.count == 1
      return true
    end
    false
  end

  def active?
    true
  end

  #TODO move to a service?
  def init_votes params, current_user_id
    #create votes for each user in the game
      game.users.each do |user|
      event_votes.create_vote_for_game user, params, current_user_id
      end
      reload

    Userpost.create_event_created(self)

  end

  def is_passing?
    if (self.yes_votes.to_f / self.game.users.count.to_f).to_f > 0.5 || self.game.users.count == 1
      true
    else
      false
    end
  end

  def deactivate
    self.update_attribute(:active,  false)
    Score.update_score(self)
    Userpost.create_game_event_passed(self)
    if self.game.is_passing?
      game.deactivate
    end
  end

end
