# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validate :verify_file_type
  has_one_attached :user_icon

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :user_icon

  private

  def verify_file_type
    return unless user_icon.attached?

    allowed_file_types = %w[image/jpg image/gif image/png]
    errors.add(:user_icon, 'only jpg, gif, png') unless allowed_file_types.include?(user_icon.blob.content_type)
  end
end
