# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for
    blogs_path
  end
end
