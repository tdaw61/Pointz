class Like < ActiveRecord::Base
  belongs_to :userpost
  belongs_to :comment
end
