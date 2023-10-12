# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test 'user_name_or_email' do
    user = User.new(email: 'alice@test', name: '')
    assert_equal 'Alice', @user.name_or_email
    assert_equal 'alice@test', user.name_or_email
  end
end
