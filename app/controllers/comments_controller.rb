# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_authorized_report, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render_commentable_show
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_authorized_report
    @comment = current_user.comments.find(params[:id])
  end
end
