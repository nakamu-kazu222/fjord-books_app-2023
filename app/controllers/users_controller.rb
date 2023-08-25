# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.order(:created_at).page(params[:page]).per(2)
  end

  def show
  end

  def edit
    redirect_to root_path, alert: t('controllers.users.edit.unauthorized') unless @user == current_user
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: t('controllers.users.update.success')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :postal_code, :address, :introduction)
  end
end
