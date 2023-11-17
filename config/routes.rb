Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  namespace :admin do
    root to: 'homes#top'
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :items, except: [:destroy]
  end

  scope module: 'public' do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :shipping_addresses, except: [:new, :show]
    resources :orders, only: [:new, :create, :index, :show, :confirm, :complete]
    resources :cart_items, only: [:index, :update, :create, :destroy, :destroy_all]
    resource :customers, only: [:show, :edit, :update], path: 'customer'
    get "customers/check"=>"customers#check",as: 'check'
    patch "customers/cancellation"=>"customers#cancellation",as: "cancellation"
    resources :items, only: [:index, :show]
  end

end
