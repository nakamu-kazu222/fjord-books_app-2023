# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true, allow_blank: true

  has_many :mentioning, class_name: 'ReportMention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioned_reports, through: :mentioning, source: :mentioned_report, inverse_of: :mentioned

  has_many :mentioned, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioning_reports, through: :mentioned, source: :mentioning_report, inverse_of: :mentioning

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def extract_mentioned_report_ids(text)
    url_pattern = %r{http://localhost:3000/reports/(\d+)}
    text.scan(url_pattern).flatten.map(&:to_i).uniq
  end

  def save_report_and_mention_with_content
    ActiveRecord::Base.transaction do
      save!
      mentioned_report_ids = extract_mentioned_report_ids(content)
      existing_mentioned_report_ids = mentioning_reports.pluck(:id)

      new_mentioned_report_ids = mentioned_report_ids - existing_mentioned_report_ids
      delete_target_report_ids = existing_mentioned_report_ids - mentioned_report_ids

      ReportMention.where(mentioned_report_id: id, mentioning_report_id: delete_target_report_ids).find_each(&:destroy!)

      new_mentioned_report_ids.each do |mentioned_report_id|
        ReportMention.create!(mentioned_report_id: id, mentioning_report_id: mentioned_report_id)
      end
    end
  end
end
