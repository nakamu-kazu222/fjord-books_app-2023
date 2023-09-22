# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      @report.save_report_and_mention_with_content(@report.content)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      @report.save_report_and_mention_with_content(@report.content)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    ActiveRecord::Base.transaction do
      ReportMention.where(mentioning_report: @report).destroy_all
      ReportMention.where(mentioned_report: @report).destroy_all
      @report.destroy
    end

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  rescue ActiveRecord::InvalidForeignKey
    redirect_to reports_url, alert: t('controllers.common.notice_not_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end

def extract_mentioned_report_ids(text)
  url_pattern = %r{http://localhost:3000/reports/(\d+)}
  text.scan(url_pattern).flatten.map(&:to_i)
end
