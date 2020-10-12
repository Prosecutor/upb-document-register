# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents

  resource :session, only: [:new, :create, :destroy]

  root to: 'documents#index'
end
