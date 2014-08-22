class LeagueUser < ActiveRecord::Base

  belongs_to :user
  belongs_to :league

  validates_presence_of :league_id, :user_id

end
