class JobsController < ApplicationController
  def index
    @queued_jobs = Job.where("email_status = ? and pdf_status = ?", false, false).order(created_at: :asc)
    @partially_processed_jobs = Job.where("(email_status = ? or pdf_status = ?) and status = ?", true, true, false).order(created_at: :asc)
    @processed_jobs = Job.where(status: true).order(created_at: :asc)
  end

  def get_published_stories
    stories = Store.published_stories
    render json: stories
  end

  private

  def story_params
    params.require(:job).permit(:id, :story_id, :publication_id, :username, :email)
  end
end
