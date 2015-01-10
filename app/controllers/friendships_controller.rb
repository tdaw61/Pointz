class FriendshipsController < ApplicationController

  def create
      friendship = current_user.friends.build(friendship_params)
      friendship
  end

  private

  def friendship_params
    params.permit(:friend_id, :id)
  end
end


