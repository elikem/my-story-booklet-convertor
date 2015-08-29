Rails.application.routes.draw do
  root to: redirect('jobs')

  resources :jobs, only: [:index]
end
