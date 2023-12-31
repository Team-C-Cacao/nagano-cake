Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  get '/search' => 'searches#search'
  get '/genre/search' => 'searches#genre_search'

  namespace :admin do
    root to: 'homes#top'
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:show,:update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update, :destroy] #便宜上追加
    resources :items, except: [:destroy]
  end

  scope module: :public do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :shipping_addresses, except: [:new, :show]
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post :confirm
        get :confirm
        get :complete
      end
    end
    resources :cart_items, only: [:index, :update, :create, :destroy] do
      collection do
        delete :destroy_all
      end
    end
    resource :customers, only: [:show] do
      collection do
        get "infomation/edit"=>:edit
        patch "infomation/edit"=>:update
        get :check
        patch :cancellation
      end
    end
    resources :items, only: [:index, :show]
  end

end
