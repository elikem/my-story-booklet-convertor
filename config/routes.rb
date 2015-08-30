Rails.application.routes.draw do
  root to: redirect('jobs')

  resources :jobs, only: [:index] do
    get 'get_published_stories', on: :collection
  end
end
