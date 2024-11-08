# frozen_string_literal: true

require 'test_helper'

class UserInfoTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:credit_card_token)
    should validate_presence_of(:user_document)
    should validate_numericality_of(:value).is_greater_than_or_equal_to(0.1)
  end
end
