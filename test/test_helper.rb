# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"
require "active_model"
require "rails/test_help"
require "view_component/test_helpers"

class ApplicationController < ActionController::Base
end

class FormComponentTestModel
  include ActiveModel::Model

  attr_accessor :bio, :document, :email, :frequency, :interests, :role, :roles, :terms
end

class ViewComponent::TestCase
  private

  def form_builder(object = FormComponentTestModel.new, object_name: :user, **options)
    ActionView::Helpers::FormBuilder.new(object_name, object, vc_test_controller.view_context, options)
  end
end
