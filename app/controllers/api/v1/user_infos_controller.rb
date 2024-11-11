# frozen_string_literal: true

class Api::V1::UserInfosController < ApplicationController
  def index
    user_infos = UserInfo.all

    render json: user_infos.map { UserInfoSerializer.new(_1).as_json }
  end

  def show
    user_info = UserInfo.find_by(id: params[:id])

    return head :not_found unless user_info

    render json: UserInfoSerializer.new(user_info).as_json
  end

  def create
    user_info = UserInfo.new(user_info_params)

    case UserInfoCreateOrUpdate.new(user_info:, params: user_info_params).execute
    in true  then render json: user_info.as_json.except('id', 'created_at', 'updated_at'), status: :created
    in false then render json: user_info.errors, status: :unprocessable_entity
    end
  end

  def update
    user_info = UserInfo.find_by(id: params[:id])

    return head :not_found unless user_info

    user_info.assign_attributes(user_info_params)

    case UserInfoCreateOrUpdate.new(user_info:, params: user_info_params).execute
    in true  then render json: UserInfoSerializer.new(user_info).as_json
    in false then render json: user_info.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user_info = UserInfo.find_by(id: params[:id])

    user_info.destroy
  end

  private

  def user_info_params
    params.require(:user_info).permit(:credit_card_token, :user_document, :value)
  end
end
