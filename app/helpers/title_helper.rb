module TitleHelper
  def fb_user_pic(uid)
    image_tag "http://graph.facebook.com/#{uid}/picture" if !uid.nil?
  end

  def fb_user_link(uid, href)
    link_to href, "http://www.facebook.com/profile.php?id=#{uid}" if !uid.nil?
  end
end
