module UsersHelper

  def profile_image(user, size=80)
    image_url = "http://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
    image_tag(image_url, alt: user.name)
  end 
end
