# frozen_string_literal: true

require "test_helper"

class Imagusu::DesignSystem::CardComponentTest < ViewComponent::TestCase
  def test_renders_semantically_neutral_card
    render_inline(component) { "Card body" }

    assert_selector "div.ids-card > .ids-card__body", text: "Card body"
  end

  def test_supports_semantic_element_header_and_footer_slots
    card = component(as: :article, html_attributes: {aria: {labelledby: "card-title"}})
    card.with_header { '<h2 id="card-title">Profile</h2>'.html_safe }
    card.with_footer { "Updated today" }

    render_inline(card) { "Ada Lovelace" }

    assert_selector "article.ids-card[aria-labelledby='card-title']"
    assert_selector ".ids-card__header h2#card-title", text: "Profile"
    assert_selector ".ids-card__body", text: "Ada Lovelace"
    assert_selector ".ids-card__footer", text: "Updated today"
  end

  def test_rejects_unknown_elements_and_attributes
    assert_raises(ArgumentError) { component(as: :a) }
    assert_raises(ArgumentError) { component(html_attributes: {onclick: "alert(1)"}) }
  end

  private

  def component(**attributes)
    Imagusu::DesignSystem::CardComponent.new(**attributes)
  end
end
