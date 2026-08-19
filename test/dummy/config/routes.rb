# frozen_string_literal: true

Rails.application.routes.draw do
  get "/gallery", to: "gallery#show"
  root to: "gallery#show"
end
