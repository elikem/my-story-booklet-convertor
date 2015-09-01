class JobsController < ApplicationController
  def index
    @queued_jobs = Job.where(status: false)
    @partially_processed_jobs = Job.where("(email_status = ? or idml_status = ?) and status = ?", true, true, false)
    @processed_jobs = Job.where(status: true)
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
