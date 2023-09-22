# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true, allow_blank: true

  has_many :mentions, class_name: 'ReportMention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioned_reports, through: :mentions, source: :mentioned_report

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_report_and_mention_with_content(content)
    mentioned_report_ids = extract_mentioned_report_ids(content)
    mentioned_reports = Report.where(id: mentioned_report_ids)

    mentioned_reports.each do |mentioned_report|
      unless mentioned_report.mentioned_reports.include?(self)
        mentioned_report.mentioned_reports << self
        mentioned_report.save
      end
    end
  end
end
