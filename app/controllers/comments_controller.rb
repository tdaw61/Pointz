class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment_count = @comment.userpost.comments.count
    if params[:picture]
      @comment.create_photo(picture: params[:picture])
    end
    @comment.save
  end


  private
  
  def comment_params
    params.require(:comment).permit(:data, :user_id, :userpost_id, :picture)
  end

end
