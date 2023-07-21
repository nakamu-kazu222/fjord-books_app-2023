class Admin::Blog < ApplicationRecord
  validates :title, :content, presence: true
end
