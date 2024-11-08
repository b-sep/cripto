# frozen_string_literal: true

class UserInfo < ApplicationRecord
  validates :credit_card_token, :user_document, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0.1 }
end
