class League < ActiveRecord::Base

  has_many :league_users
  has_many :users, :through => :league_users
  has_many :games

  accepts_nested_attributes_for :games

  validates_presence_of :name
  validates_length_of :name, maximum: 30, message: "30 characters max for game name"



end
