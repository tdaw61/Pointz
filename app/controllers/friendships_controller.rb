class FriendshipsController < ApplicationController
  before_action :set_friendship

  #accept friendship, this will need to update friendships in 2 directions.
  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
    else
      flash[:notice] = "There has been no friendship request"
    end
  end

  #this will take care of rejecting, cancelling, and unfriending.
  def destroy
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship Deleted"
    else
      flash[:notice] = "No Friendship to delete"
    end
  end

  #Send a friendship request
  def create
    Friendship.request(@user, @friend)
  end

  private
  def set_friendship
    @user = current_user
    @friend = User.find(params[:id])
  end

  def friendship_params
    params.permit(:friend_id, :id)
  end
end


