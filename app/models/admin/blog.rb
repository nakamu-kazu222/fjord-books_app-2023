class Admin::Blog < ApplicationRecord
  include ActiveModel::Validations
  validates :title, :content, presence: true
  validates_with MyValidator

  after_commit :delete_blog, on: :destroy

  def delete_blog
    if destroyed?
      puts '削除された'
    else
      puts '削除に失敗した'
    end
  end
end
