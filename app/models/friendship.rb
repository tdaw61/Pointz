class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User"

  FRIENDSHIP_STATUSES = ["accepted", "pending", "requested"]

  validates_presence_of :friend_id, :user_id

# Return true if the users are (possibly pending) friends.
  def self.exists?(user, friend)
    !find_by_user_id_and_friend_id(user, friend).nil?
  end

  # Record a pending friend request.
  def self.request(user, friend)
    unless user == friend or Friendship.exists?(user, friend)
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status =>
            'requested')
      end
    end
  end

  # Accept a friend request.
  def self.accept(user, friend)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, friend, accepted_at)
      accept_one_side(friend, user, accepted_at)
    end
  end

  # Delete a friendship or cancel a pending request.
  def self.destroy_friendship(user, friend)
    transaction do
      destroy(find_by_user_id_and_friend_id(user, friend))
      destroy(find_by_user_id_and_friend_id(friend, user))
    end
  end

  private

  # Update the db with one side of an accepted friendship request.
  def self.accept_one_side(user, friend, accepted_at)
    request = find_by_user_id_and_friend_id(user, friend)
    request.status = 'accepted'
    request.accepted_time = accepted_at
    request.save!
  end
end
