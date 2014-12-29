class Userpost < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :likes

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :data, presence: true, length: { maximum: 140, message: "Content must be under 140 characters." }

  mount_uploader :picture, PictureUploader

  def target_username
    User.find(self.target_user_id).name
  end

  def target_user
    User.find(self.target_user_id)
  end

  def event_create_post game_event
     Userpost.create!({:points => self.point_value, :data => self.data, :user_id => self.user_id, :game_id => self.game_id, :target_user_id => self.target_user_id})
  end

  def positive_likes
    likes.where(like: true).count
  end

  def negative_likes
    likes.where(like: false).count
  end

end
