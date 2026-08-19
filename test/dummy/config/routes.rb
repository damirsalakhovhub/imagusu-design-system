# frozen_string_literal: true

Rails.application.routes.draw do
  get "/gallery", to: "gallery#show"
  root to: "gallery#show"

  if Rails.env.development? && defined?(Lookbook)
    mount Lookbook::Engine, at: "/components"
  end
end
