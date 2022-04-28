# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :bolt, only: [:show, :edit, :update]
  end

  post '/webhooks/bolt', to: '/solidus_bolt/webhooks#update'

  post '/transactions/authorize', to: '/solidus_bolt/transactions#authorize'
end
