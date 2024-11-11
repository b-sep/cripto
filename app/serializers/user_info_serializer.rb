# frozen_string_literal: true

class UserInfoSerializer < ActiveModel::Serializer
  attribute :credit_card_token
  attribute :user_document
  attribute :value

  def credit_card_token = Cipher.decrypt(object.credit_card_token)
  def user_document     = Cipher.decrypt(object.user_document)
end
