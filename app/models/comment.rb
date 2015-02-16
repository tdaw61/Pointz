class Comment < ActiveRecord::Base
  belongs_to :userpost
  belongs_to :user
  has_many :likes

  has_one  :photo, as: :picture
  accepts_nested_attributes_for :photo

  def positive_likes
    likes.where(like: true).count
  end

  def negative_likes
    likes.where(like: false).count
  end
end
