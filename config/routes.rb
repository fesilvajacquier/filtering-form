Rails.application.routes.draw do
  root to: "movies#index"
  resources :movies, only: :index do
    collection do
      get :filter
    end
  end
end
