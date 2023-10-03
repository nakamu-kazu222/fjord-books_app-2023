# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user1)
  end

  test 'user_name_or_email' do
    user = User.new(email: 'test@test', name: '')
    assert_equal 'user1', @user.name_or_email
    assert_equal 'test@test', user.name_or_email
  end
end
