class League < ActiveRecord::Base

  has_many :league_users
  has_many :users, :through => :league_users
  has_many :games

  accepts_nested_attributes_for :games



end
