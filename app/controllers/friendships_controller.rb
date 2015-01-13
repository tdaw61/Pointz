class FriendshipsController < ApplicationController

  def create
      @friendship = current_user.friendships.build({friend_id: params[:friend_id]})
      @friendship.save
  end

  def friend_request_accept
    # accepting a friend request is done by the recipient of the friend request.
    # thus the current user is identified by to_id.

    friendable = Friendship.where(friend_id: current_user.id, user_id: params[:id]).first
    friendable.update_attributes(accepted: true)
  end

  #this works to destroy a friendship for when someone unfollows as well as when someone rejects.
  def destroy
    friendable = Friendship.where(user_id: current_user.id, friend_id: params[:id]).first
    friendable.destroy
  end

  private

  def friendship_params
    params.permit(:friend_id, :id)
  end
end


