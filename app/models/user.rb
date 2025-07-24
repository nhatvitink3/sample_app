class User < ApplicationRecord
  has_secure_password

  USER_PERMIT = %i(name birthday gender email password
    password_confirmation).freeze

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum gender: {male: 0, female: 1, other: 2}

  validates :name, presence: true,
    length: {maximum: Settings.user.max_name_length}
  validates :email, presence: true,
    length: {maximum: Settings.user.max_email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :birthday, presence: true
  validates :gender, presence: true

  validate :birthday_within_limit

  before_save :downcase_email

  private

  def birthday_within_limit
    return if birthday.blank? || !birthday.is_a?(Date)

    current_date = Time.zone.today
    limit = current_date.prev_year(Settings.user.birthday_y_limit)

    if birthday > current_date
      errors.add(:birthday, :cannot_be_in_the_future)
    elsif birthday < limit
      errors.add(:birthday, :must_be_within_100_years)
    end
  end

  def downcase_email
    email.downcase!
  end
end
