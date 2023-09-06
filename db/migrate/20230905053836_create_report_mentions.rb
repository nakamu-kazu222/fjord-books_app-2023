class CreateReportMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentions do |t|
      t.references :mentioning_report, null: false, foreign_key: { to_table: :reports, on_delete: :cascade }
      t.references :mentioned_report, null: false, foreign_key: { to_table: :reports, on_delete: :cascade }
            
      t.timestamps
    end
  end
end
