class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment_count = @comment.userpost.comments.count
    @comment.save
  end


  private
  
  def comment_params
    params.require(:comment).permit(:data, :user_id, :userpost_id)
  end

end
