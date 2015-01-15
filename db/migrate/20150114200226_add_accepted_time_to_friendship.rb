class AddAcceptedTimeToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :accepted_time, :time
  end
end
