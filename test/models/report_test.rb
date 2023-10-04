# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @report_user1 = reports(:report_user1)
    @report_user2 = reports(:report_user2)
    @report_user3 = reports(:report_user3)
  end

  test 'editable?' do
    assert @report_user1.editable?(@user1)
    assert_not @report_user1.editable?(@user3)
  end

  test 'created_on' do
    assert_equal Date.parse('Wed, 04 Oct 2023'), @report_user1.created_on
    assert_not_equal Date.parse('Tue, 10 Oct 2023'), @report_user1.created_on
  end

  test 'save_mentions' do
    assert_equal [], @report_user1.send(:save_mentions)

    assert_equal [@report_user1], @report_user3.send(:save_mentions)

    @report_user3.update(content: 'http://localhost:3000/reports/1 http://localhost:3000/reports/2')
    assert_equal [@report_user1, @report_user2], Report.find(@report_user3.id).send(:save_mentions)

    @report_user3.update(content: 'http://localhost:3000/reports/1')
    assert_equal [@report_user1], Report.find(@report_user3.id).send(:save_mentions)
  end
end
