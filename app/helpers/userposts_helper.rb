module UserpostsHelper

  def has_liked_link
     link_to (@like.like ? "Unlike" : "Un-dislike") , like_path(id: @like.id), method: :delete, remote: true, class: "opacity-thirtyfive feed-item-link", id: "like_dislike_link"
  end

  #Returns true if the user has not liked/disliked this userpost.
  #TODO refactor to use userpost likes so it can be eager loaded
  def has_liked_userpost(feed_item)
    @like = Like.where(user_id: current_user.id, userpost_id: feed_item.id).first
    !@like.nil?
  end

end