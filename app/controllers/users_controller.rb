# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.order(:created_at).page(params[:page]).per(2)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    redirect_to root_path, alert: 'Cannot edit information for other users' unless @user == current_user
  end

  def update
    @user = set_user

    if @user.update(user_params)
      redirect_to root_path, notice: 'Your account information has been updated'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :postal_code, :address, :introduction)
  end
end
