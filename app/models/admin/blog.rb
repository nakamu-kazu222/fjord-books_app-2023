class Admin::Blog < ApplicationRecord
  validates :content, format: { with: /\A[a-zA-Z]+\z/,message: "は、英文字のみが使えます" }
end
