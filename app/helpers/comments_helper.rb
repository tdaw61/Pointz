module CommentsHelper

  def has_liked_comment(feed_item)
    @like = Like.where(user_id: current_user.id, comment_id: feed_item.id).first
    !@like.nil?
  end

end