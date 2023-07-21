class Admin::Blog < ApplicationRecord
  validates :title, :content, presence: true, if: :title_or_content_present?

  def title_or_content_present?
    title.present? || content.present?
  end
end
