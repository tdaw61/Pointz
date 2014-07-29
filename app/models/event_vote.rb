class EventVote < ActiveRecord::Base

  belongs_to :game_event
  belongs_to :user
  belongs_to :game

  def username
    User.find(self.target_user_id).name
  end

  def vote_string
    if vote?
      "Yes"
    else
      "No"
    end
  end


end
