module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 60 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  #could be made into a hash for options??
  def avatar_for(object, type, css_class, size, css_id)
    if(object.picture.present?)
      case type
        when "small"
          image_tag(object.picture.small_avatar.url.to_s, class: css_class, alt: object.name, size: size, id: css_id)
        when "medium"
          image_tag(object.picture.medium_avatar.url.to_s, class: css_class, size: size, id: css_id)
        when "large"
          image_tag(object.picture.large_avatar.url.to_s, class: css_class, size: size, id: css_id)
        else
          image_tag(PictureUploader.default_avatar.medium_avatar.url)
      end
    else
      case type
        when "small"
          image_tag('small_avatar_default_avatar.jpeg', class: css_class, id: css_id)
        when "medium"
          image_tag('medium_avatar_default_avatar.jpeg', class: css_class, id: css_id)
        when "large"
          image_tag('large_avatar_default_avatar.jpeg', class: css_class, id: css_id)
        else
          image_tag(PictureUploader.default_avatar.medium_avatar.url)
      end
    end
  end

  def friend_link search_user, type

    if current_user.id == search_user.id
       #Do nothing
    elsif(current_user.pending_friends.include?(search_user))
      link_to 'Cancel Friend Request',  friendships_path(id: search_user.id, from: request.params[:action]), method: :delete, remote: true, data: 'Are you sure you want to unfriend this person?', class: 'padding-left btn btn-sm btn-danger', id: "friend_link_#{search_user.id}"
    elsif(current_user.requested_friends.include?(search_user))
      content_tag :div, id: "friend_link_#{search_user.id}" do
        html = link_to type == 'long' ? "Accept Friend Request" : "Accept", accept_friendship_path(id: search_user.id, from: request.params[:action] ), method: :post, remote: true, class: "padding-left btn btn-sm btn-danger margin-right", data: {disable_with: "Processing"}
        html += link_to type == 'long' ? "Reject Friend Request" : "Reject", friendship_path(id: search_user.id, from: request.params[:action]), method: :delete, remote: true, class: "padding-left btn btn-sm btn-danger", data: {disable_with: "Processing"}
      end
    elsif(current_user.friends.include?(search_user))
      link_to 'UnFriend',  friendship_path(id: search_user.id, from: request.params[:action]), method: :delete, remote: true, data: "Are you sure you want to unfriend this person?", class: "padding-left btn btn-sm btn-danger", id: "friend_link_#{search_user.id}"
    else
      link_to 'Add as Friend', friendships_path(id: search_user.id), method: :post, remote: true, class: "padding-left btn btn-sm btn-danger", data: {disable_with: "Processing"}, id: "friend_link_#{search_user.id}"
    end
  end
end
