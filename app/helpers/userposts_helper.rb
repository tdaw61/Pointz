module UserpostsHelper

  def has_liked_link
     link_to (@like.like ? "Unlike" : "Un-dislike") , like_path(id: @like.id), method: :delete, remote: true, class: "opacity-thirtyfive feed-item-link", id: "like_dislike_link"
  end

  #Returns true if the user has not liked/disliked this userpost.
  #TODO REFACTOR - refactor to use userpost likes so it can be eager loaded
  def has_liked_userpost(feed_item)
    feed_item.likes.map(&:user_id).include? current_user.id
  end

end