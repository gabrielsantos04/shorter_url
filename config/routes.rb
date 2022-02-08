Rails.application.routes.draw do
  resources :paginas do
    collection do
      get :jsonapi
    end
  end
  get ':short_url', to: 'paginas#visit', as: :visit


end
