module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 60 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def avatar_for(object)
    if request[:action] == 'home'
      image_tag(object.picture.medium_avatar.url.to_s)
    else
      image_tag(object.picture.large_avatar.url.to_s)
    end
  end


end
