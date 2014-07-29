class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_presence_of :point_value

  def has_passed?
    if (yes_votes / self.game.users.size) > 0.5
      return true
    end
    false
  end

end
