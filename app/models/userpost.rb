class Userpost < ActiveRecord::Base
  has_one  :photo, as: :picture
  accepts_nested_attributes_for :photo
  belongs_to :user
  belongs_to :game
  has_many :likes
  has_many :comments
  has_many :positive_likes, -> {where(like: true).count}, class_name: "Like"
  has_many :negative_likes, -> {where(like: false).count}, class_name: "Like"

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :data, presence: true, length: { maximum: 140, message: "Content must be under 140 characters." }


  def target_username
    User.find(self.target_user_id).name
  end

  def target_user
    User.find(self.target_user_id)
  end

  def positive_likes
    likes.where(like: true).count
  end

  def negative_likes
    likes.where(like: false).count
  end

  def event_create_post game_event
    Userpost.create!({:points => self.point_value, :data => self.data, :user_id => self.user_id, :game_id => self.game_id, :target_user_id => self.target_user_id, post_type: "userpost"})
  end

  def self.create_game_event_passed(game_event)
    post_data = game_event.target_user.name + " has received " + game_event.point_value.to_s + " points from " + game_event.user.name + "'s vote"
    Userpost.create!(data: post_data, target_user_id: game_event.target_user_id, user_id: game_event.user_id, post_type: "vote_ended", game_id: game_event.game_id, points: game_event.point_value)
  end

  def self.create_event_created(game_event, photo)
    Userpost.create!({points: game_event.point_value, data: game_event.data, user_id: game_event.user_id, game_id: game_event.game_id, target_user_id: game_event.target_user_id, post_type: "event_created", photo: photo})
  end

  def self.create_game_winner(game)
    post_data = game.leader.name + " has won the game! Better luck next time to everyone else."
    Userpost.create!({data: post_data, post_type: "game_winner"})
  end

end
