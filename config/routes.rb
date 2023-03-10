require 'api_version_constraint'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, defaults: { format: :json }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resource :registrations, only: [:create]
      resource :sessions, only: [:create]
      resources :users, only: [:index, :show, :update, :destroy]
      post '/users/change_role_admin', to: 'users#change_role_admin', as: :change_role_admin

      resources :subjects, only: [:index, :create, :update, :destroy]
      resources :exams, only: [:index, :show, :create, :update, :destroy] do
        resources :questions, only: [:show, :create]
      end
      resources :questions, only: [:index, :update, :destroy] do
        resources :answers, only: [:create]
      end
      resources :answers, only: [:show, :index, :update, :destroy]
      resources :user_exams, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
