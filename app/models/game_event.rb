class GameEvent < ActiveRecord::Base
  belongs_to :game

  validates_presence_of :point_value
end
