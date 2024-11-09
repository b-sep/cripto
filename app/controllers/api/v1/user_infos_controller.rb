# frozen_string_literal: true

class Api::V1::UserInfosController < ApplicationController
  def index
    @user_infos = UserInfo.all

    render json: @user_infos.as_json.map { |info| info.except('id', 'created_at', 'updated_at') }
  end

  def show
    @user_info = UserInfo.find_by(id: params[:id])

    return head :not_found unless @user_info

    render json: @user_info.as_json.except('id', 'created_at', 'updated_at')
  end

  def create
    @user_info = UserInfo.new(user_info_params)

    return render json: @user_info.errors, status: :unprocessable_entity if @user_info.invalid?

    @user_info.save

    render json: @user_info.as_json.except('id', 'created_at', 'updated_at'), status: :created
  end

  def update
    @user_info = UserInfo.find_by(id: params[:id])

    return head :not_found unless @user_info
    return render json: @user_info.errors, status: :unprocessable_entity unless @user_info.update(user_info_params)

    render json: @user_info.as_json.except('id', 'created_at', 'updated_at')
  end

  def destroy
    @user_info = UserInfo.find_by(id: params[:id])

    @user_info.destroy
  end

  private

  def user_info_params
    params.require(:user_info).permit(:credit_card_token, :user_document, :value)
  end
end
