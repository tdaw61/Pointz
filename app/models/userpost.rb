class Userpost < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :data, presence: true, length: { maximum: 140, message: "Content must be under 140 characters." }

  def target_username
    User.find(self.target_user_id).name
  end

  def target_user
    User.find(self.target_user_id)
  end

end
