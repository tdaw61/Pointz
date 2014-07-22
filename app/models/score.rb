class Score < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  # validates_presence_of :points

  def username
    user = User.find(self.user_id)
    user.name
  end

end
