Rails.application.routes.draw do
  root to: redirect('jobs')

  resources :jobs, only: [:index] do
    get 'get_published_stories', on: :collection
  end

  # get 'published_stories', to: 'jobs#published_stories'
end
