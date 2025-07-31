module UsersHelper
  GRAVATAR_SIZE = 50

  def gravatar_for user, options = {size: GRAVATAR_SIZE}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "#{Settings.user.gravatar_link}#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def gender_options
    User.genders.keys.map do |g|
      [t("genders.#{g}"), g]
    end
  end

  def can_delete_user? user
    current_user.admin? && !current_user?(user)
  end
end
