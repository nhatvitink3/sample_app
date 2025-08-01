class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  MAX_IMAGE_SIZE = 5.megabytes
  MICROPOST_PERMITTED = %i(content image).freeze
  MEGABYTE_IN_BYTES = 1.megabyte.freeze
  IMAGE_DISPLAY_SIZE = [500, 500].freeze

  scope :recent_posts, -> {order(created_at: :desc)}
  scope :relate_posts, ->(user_ids) {where user_id: user_ids}

  validates :content, presence: true,
length: {maximum: Settings.digits.digit_140}

  validates :image,
            content_type: {in: Settings.allowed_image_types,
                           message: :invalid_image_format},
            size: {less_than: MAX_IMAGE_SIZE,
                   message: :image_size_too_large}

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: IMAGE_DISPLAY_SIZE
  end
end
