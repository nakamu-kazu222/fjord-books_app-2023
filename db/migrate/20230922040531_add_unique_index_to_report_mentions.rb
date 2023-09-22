class AddUniqueIndexToReportMentions < ActiveRecord::Migration[7.0]
  def change
    add_index :report_mentions, [:mentioning_report_id, :mentioned_report_id], unique: true, name: 'index_report_mentions_on_reports'
  end
end
