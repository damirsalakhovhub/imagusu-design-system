# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development? && defined?(Lookbook)
    mount Lookbook::Engine, at: "/components"
    get "/gallery", to: redirect("/components/preview/imagusu/design_system/gallery/default")
    root to: redirect("/gallery")
  end
end
