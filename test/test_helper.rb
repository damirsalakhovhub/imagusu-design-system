# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "dummy/config/environment"
require "active_model"
require "rails/test_help"

class FormComponentTestModel
  include ActiveModel::Model

  attr_accessor :email
end
