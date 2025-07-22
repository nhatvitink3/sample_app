class Micropost < ApplicationRecord
  scope :newest, -> {order(created_at: :desc)}
end
