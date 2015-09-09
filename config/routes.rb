# == Route Map
#
#                     Prefix Verb URI Pattern                           Controller#Action
#                       root GET  /                                     redirect(301, jobs)
# get_published_stories_jobs GET  /jobs/get_published_stories(.:format) jobs#get_published_stories
#                       jobs GET  /jobs(.:format)                       jobs#index
#

Rails.application.routes.draw do
  root to: redirect('jobs')

  resources :jobs, only: [:index] do
    get 'get_published_stories', on: :collection
  end
end
