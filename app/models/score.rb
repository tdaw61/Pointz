class Score < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  # validates_presence_of :points

  def username
    User.find(:user_id)
  end

end
