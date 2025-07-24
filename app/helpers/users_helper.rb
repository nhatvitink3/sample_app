module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "#{Settings.user.gravatar_link}#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def gender_options
    User.genders.keys.map do |g|
      [t("genders.#{g}"), g]
    end
  end
end
