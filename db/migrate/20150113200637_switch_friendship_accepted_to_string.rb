class SwitchFriendshipAcceptedToString < ActiveRecord::Migration
  def change
    change_column :friendships, :accepted, :string
  end
end
