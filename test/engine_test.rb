# frozen_string_literal: true

require "test_helper"

class EngineTest < ActiveSupport::TestCase
  test "engine loads packaged components" do
    assert_kind_of Class, Imagusu::DesignSystem::Engine
    assert_kind_of Class, Imagusu::DesignSystem::ButtonComponent
    assert Imagusu::DesignSystem::ButtonComponent < ViewComponent::Base
  end

  test "engine eager loads packaged components" do
    Rails.application.eager_load!

    assert_kind_of Class, Imagusu::DesignSystem::ButtonComponent
    assert_kind_of Class, Imagusu::DesignSystem::AlertComponent
    assert_kind_of Class, Imagusu::DesignSystem::BadgeComponent
    assert_kind_of Class, Imagusu::DesignSystem::CardComponent
    assert_kind_of Class, Imagusu::DesignSystem::CheckboxComponent
    assert_kind_of Class, Imagusu::DesignSystem::CheckboxGroupComponent
    assert_kind_of Class, Imagusu::DesignSystem::ErrorSummaryComponent
    assert_kind_of Class, Imagusu::DesignSystem::FieldComponent
    assert_kind_of Class, Imagusu::DesignSystem::FileUploadComponent
    assert_kind_of Class, Imagusu::DesignSystem::LinkComponent
    assert_kind_of Class, Imagusu::DesignSystem::RadioGroupComponent
    assert_kind_of Class, Imagusu::DesignSystem::SelectComponent
    assert_kind_of Class, Imagusu::DesignSystem::TextAreaComponent
    assert_kind_of Class, Imagusu::DesignSystem::TextFieldComponent
  end
end
