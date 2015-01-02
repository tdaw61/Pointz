class Comment < ActiveRecord::Base
  belongs_to :userpost
  belongs_to :user
  has_many :likes

  mount_uploader :picture, PictureUploader

  def positive_likes
    likes.where(like: true).count
  end

  def negative_likes
    likes.where(like: false).count
  end
end
