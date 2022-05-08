Rails.application.routes.draw do
  root to: 'homes#top'
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

  namespace :admin do
    resources:customers,only:[:index,:show]
    resources:parks,only:[:index,:show,:destroy]
  end

  namespace :public do
    resources:parks,only:[:new,:create,:show,:index,:destroy] do
      resources:comments,only:[:create]
      resource:favorites,only:[:create,:destroy]
    end
    resources:customers,only:[:index,:show,:edit,:update] do
      resource:relationships,only:[:create,:destroy,:show]
    end
    resources:notifications,only:[:index]
    get 'searches/search'
    resources:contacts,only:[:new,:create]
  end
  # 退会確認画面
  get 'customers/:id/unsubscribe' => 'public/customers#unsubscribe', as: 'unsubscribe'
  # 論理削除用のルーティング
  patch 'customers/:id/withdrawal' => 'public/customers#withdrawal', as: 'withdrawal'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
