class Admin::Blog < ApplicationRecord
  include ActiveModel::Validations
  validates :title, :content, presence: true
  # validates_with MyValidator
end
