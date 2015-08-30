class JobsController < ApplicationController
  def index
    # render json: Parse.published_stories
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
