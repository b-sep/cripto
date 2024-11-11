# frozen_string_literal: true

class UserInfoCreateOrUpdate
  private attr_accessor :params, :user_info

  def initialize(user_info:, params:)
    @user_info = user_info
    @params = params
  end

  def execute
    return false unless user_info.valid?

    user_info.credit_card_token = Cipher.encrypt(user_info.credit_card_token) if params[:credit_card_token]
    user_info.user_document     = Cipher.encrypt(user_info.user_document) if params[:user_document]

    user_info.save
  end
end
