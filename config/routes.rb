Rails.application.routes.draw do
  root :to =>'homes#top'
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin,skip: [:registrations, :passwords],controllers: {
    sessions: "admin/sessions"
  }
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords],controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'customers/sessions#guest_sign_in'
  end

  namespace :admin do
    resources:customers,only:[:index,:show,:edit,:update]
    resources:parks,only:[:index,:show,:destroy] do
      resources:comments,only:[:destroy]
    end
  end

  namespace :public do
    resources:parks,only:[:new,:create,:show,:index,:destroy,:edit,:update] do
      resources:comments,only:[:create,:destroy]
      resource:favorites,only:[:create,:destroy,:show]
    end
    resources:customers,only:[:index,:show,:edit,:update] do
      resource:relationships,only:[:create,:destroy,:show]
    end
    resources:notifications,only:[:index,:destroy]
    get 'searches/search'
    resources:contacts,only:[:new,:create]
  end
  # 退会確認画面
  get 'customers/:id/unsubscribe' => 'public/customers#unsubscribe', as: 'unsubscribe'
  # 論理削除用のルーティング
  patch 'customers/:id/withdrawal' => 'public/customers#withdrawal', as: 'withdrawal'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



end
