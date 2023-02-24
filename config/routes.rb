require 'api_version_constraint'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resource :registrations, only: [:create]
      resource :sessions, only: [:create]
      resources :users, only: [:index, :show, :update, :destroy]
      resources :school_subjects, only: [:index, :create, :update, :destroy]
      resources :exams, only: [:index, :show, :create, :update, :destroy]
      resources :questions, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
