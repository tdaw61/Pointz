class EventVote < ActiveRecord::Base

  validates_presence_of :user_point_value

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

  def self.create_vote_for_game(user, params, current_user_id)
    vote = self.new({
        :target_user_id => params[:game_event][:target_user_id],
        :game_id => params[:game_event][:game_id].to_i,

        :user_id => user.id,
        :user_point_value => params[:game_event][:point_value].to_i})
    if(user.id == current_user_id)
      vote.vote = 1
      vote.has_voted = true
    else
      vote.has_voted = false
    end
    vote
  end

  def cast_vote params
    self.vote = params[:vote]
    self.has_voted = 1
    if(params[:vote].to_i == 1)
      yes_votes = self.game_event.yes_votes+=1
      self.game_event.update_attribute(:yes_votes ,  yes_votes)
    end
  end

end
