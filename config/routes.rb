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

  namespace :public do
    resources:parks,only:[:new,:create,:show,:index] do
      resources:comments,only:[:create]
      resource:favorites,only:[:create,:destroy]
    end
    resources:customers,only:[:index,:show,:edit,:update] do
      resource:relationships,only:[:create,:destroy]
    end
    get 'searches/search'

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
