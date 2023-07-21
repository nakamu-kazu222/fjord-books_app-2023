class Admin::Blog < ApplicationRecord
  validates :content, numericality: { only_integer: true }
end
