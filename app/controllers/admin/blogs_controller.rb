# frozen_string_literal: true

class Admin::BlogsController < ApplicationController
  before_action :set_blog, only: %i[show edit update destroy]
  after_action :show_alert_after_action, only: %i[show edit update destroy]
  around_action :show_alert_around_action, only: %i[show edit update destroy]

  def index
    @blogs = Admin::Blog.all
  end

  def show
  end

  def new
    @blog = Admin::Blog.new
  end

  def edit
  end

  def create
    @blog = Admin::Blog.new(blog_params)

    if @blog.save
      redirect_to admin_blog_url(@blog), notice: 'blog was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end      

  def update
    if @blog.update(blog_params)
      redirect_to admin_blog_url(@blog), notice: 'blog was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    redirect_to admin_blogs_url, notice: 'blog was successfully destroyed.'
  end

  private

  def set_blog
    @blog = Admin::Blog.find(params[:id])
  end

  def blog_params
    params.require(:admin_blog).permit(:title, :content)
  end

  def show_alert_after_action
    puts 'After Action!'
  end  

  def show_alert_around_action
    puts 'Around Action: Something is about to happen!'

    yield

    puts 'Around Action: Something happened!'
  end
end
