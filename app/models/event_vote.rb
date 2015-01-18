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
    if (game_event.yes_votes.to_f / game_event.game.users.count.to_f).to_f > 0.5 || game_event.game.users.count == 1
      post_data = game_event.target_user.name + " has received " + game_event.point_value.to_s + " points from " + game_event.user.name + "'s vote"
      transaction do
      Userpost.create(data: post_data, target_user_id: game_event.target_user_id, user_id: game_event.user_id, post_type: "vote_ended", game_id: game_event.game_id, points: game_event.point_value)
      self.game_event.update_attribute(:active,  false)
      end
      game_event.active = false
    end
  end

end
