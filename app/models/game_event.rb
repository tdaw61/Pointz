class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  has_many :event_votes

  validates_presence_of :point_value, :target_user_id, :user_id, :game_id, :data

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

  def init_votes params, current_user_id
    #create votes for each user in the game
      game.users.each do |user|
      event_votes.create_vote_for_game user, params, current_user_id
      end
      reload

    if !active
      Score.update_score self
    end

    create_userpost
  end



end
