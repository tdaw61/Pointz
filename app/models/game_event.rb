class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_presence_of :point_value



end
