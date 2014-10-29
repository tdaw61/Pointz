class Score < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  validates_presence_of :points, :game_id, :user_id


  def username
    user.name
  end

  def create_for_league users, game_id
    users.each do |user|
      self.create!({:user_id => user.id, :game_id =>   game_id})
    end
  end

  def self.update_score game_event
    score = self.where(:game_id => game_event.game_id, :user_id => game_event.target_user_id).first
    score.points+= game_event.point_value
    score.save!
  end

end
