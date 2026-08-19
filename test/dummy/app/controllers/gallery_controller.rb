# frozen_string_literal: true

class GalleryController < ActionController::Base
  protect_from_forgery with: :exception

  def show
    render layout: "gallery"
  end
end
