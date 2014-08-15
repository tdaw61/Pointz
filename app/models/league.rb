class League < ActiveRecord::Base
  has_many :users, :through => :scores
  has_many :games



end
