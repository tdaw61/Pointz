class LikesController < ApplicationController

  def create
    @like = Like.create(like_params)

  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy!
  end


  private

  def like_params
    params.permit(:like, :user_id, :userpost_id, :comment_id)
  end
end
