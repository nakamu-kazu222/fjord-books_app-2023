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
      mentioned_reports = Report.where(id: mentioned_report_ids)

      mentioned_reports.each do |mentioned_report|
        unless mentioned_report.mentioned_reports.include?(self)
          mentioned_report.mentioned_reports << self
          mentioned_report.save!
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Error during save_report_and_mention_with_content: #{e.message}"
    raise ActiveRecord::Rollback
  end

  def remove_mentions
    mentioned_reports.each do |mentioned_report|
      mentioned_report.mentioned_reports.delete(self)
    end
  end
end
