# frozen_string_literal: true

class GalleryController < ActionController::Base
  def show
    render layout: "gallery"
  end
end
