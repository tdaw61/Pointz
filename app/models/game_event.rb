class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  has_many :event_votes

  validates_presence_of :point_value, :target_user_id, :user_id, :game_ide

  def has_passed?
    if (yes_votes.to_f / self.game.users.count.to_f).to_f > 0.5
      return true
    end
    false
  end

end
