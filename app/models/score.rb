class Score < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  validates_presence_of :points, :game_id, :user_id

  def username
    user = User.find(self.user_id)
    user.name
  end

  def create_for_league users, game_id
    users.each do |user|
      self.create!({:user_id => user.id, :game_id =>   game_id})
    end
  end

end
