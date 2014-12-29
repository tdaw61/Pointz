class Comment < ActiveRecord::Base
  belongs_to :userpost
end
