class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  USER_PERMIT = %i(name birthday gender email password
    password_confirmation).freeze

  PASSWORD_RESET_PERMITTED = %i(
    password password_confirmation
  ).freeze

  PASSWORD_EXPIRATION_TIME = 2.hours

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum gender: {male: 0, female: 1, other: 2}

  scope :recent, -> {order(created_at: :desc)}

  validates :name, presence: true,
    length: {maximum: Settings.user.max_name_length}
  validates :password, presence: true,
    length: {minimum: Settings.digits.digit_6}, allow_nil: true
  validates :email, presence: true,
    length: {maximum: Settings.user.max_email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :birthday, presence: true
  validates :gender, presence: true

  validate :birthday_within_limit

  before_save :downcase_email

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < PASSWORD_EXPIRATION_TIME.ago
  end

  def send_password_change_notification
    UserMailer.password_changed(self).deliver_now
  end
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

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
