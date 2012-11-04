MindOverflow::Application.routes.draw do

  devise_for :users

  resources :users

  resources :articles do
    collection do
      get :tag
      get :autocomplete_tag_name

    end
    member do
      get :favorite
      get :unfavorite
    end

    resources :rates, :only => [] do
      collection do
        get :minus
        get :plus
      end
    end
  end

  root :to => "articles#index"

end
