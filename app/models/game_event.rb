class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  has_many :event_votes

  validates_presence_of :point_value, :target_user_id, :user_id, :game_id

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

  def create_userpost
    Userpost.create!({:points => self.point_value, :data => self.data, :user_id => self.user_id, :game_id => self.game_id, :target_user_id => self.target_user_id})
  end

end
