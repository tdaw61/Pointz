class EventVote < ActiveRecord::Base

  validates_presence_of :user_point_value

  belongs_to :game_event
  belongs_to :user
  belongs_to :game

  def username
    User.find(self.target_user_id).name
  end

  def vote_string
    if vote.nil?
      return "N/A"
    end
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
    if user.id == current_user_id
      vote.cast_vote 1
    else
      vote.has_voted = false
    end
    vote.save!
  end

  def cast_vote yes_no
    self.vote = yes_no
    self.has_voted = 1
    self.save
    if yes_no == 1
      yes_votes = self.game_event.yes_votes+=1
      self.game_event.update_attribute(:yes_votes ,  yes_votes)
    end

    #check if game event is now passing
    if self.game_event.is_passing?
      self.game_event.deactivate
    end
  end

end
