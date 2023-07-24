class MyValidator < ActiveModel::Validator
  def validate(record)
    unless record.title&.start_with?('あ') || record.content&.start_with?('X')
      record.errors.add(:base, "タイトルまたはコンテンツは'あ'で始まる必要があります")
    end
  end
end
