# frozen_string_literal: true

require 'test_helper'
require 'minitest/autorun'

# https://semaphoreci.com/community/tutorials/mocking-in-ruby-with-minitest
class Api::V1::UserInfosControllerTest < ActionDispatch::IntegrationTest
  test 'gets user infos list' do
    UserInfo.delete_all

    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: 'token111', user_document: '111999', value: 10 } }
    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: 'token222', user_document: '222999', value: 20 } }
    get api_v1_user_infos_path

    assert_response :ok
    assert_equal([
      {
        'credit_card_token' => 'token111',
        'user_document' => '111999',
        'value' => 10
      },
      {
        'credit_card_token' => 'token222',
        'user_document' => '222999',
        'value' => 20
      }
    ], response.parsed_body)
  end

  test 'get user infos' do
    UserInfo.delete_all

    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: 'token222', user_document: '222999', value: 10 } }
    get api_v1_user_info_path(UserInfo.last)

    assert_response :ok
    assert_equal({
                   'credit_card_token' => 'token222',
                   'user_document' => '222999',
                   'value' => 10
                 }, response.parsed_body)
  end

  test 'returns 404 if user info isnt found' do
    get api_v1_user_info_path('invalid')

    assert_response :not_found
  end

  test 'creates an user info' do
    Cipher.stub :encrypt, 'encrypted_value' do
      assert_difference('UserInfo.count', +1) do
        post api_v1_user_infos_path,
             params: { user_info: { credit_card_token: 'token222', user_document: '222999', value: 10 } }

        assert_response :created
        assert_equal({
                       'user_document' => 'encrypted_value',
                       'credit_card_token' => 'encrypted_value',
                       'value' => 10
                     }, response.parsed_body)
      end
    end
  end

  test 'returns json with errors if params are invalid' do
    assert_no_difference('UserInfo.count') do
      post api_v1_user_infos_path,
           params: { user_info: { credit_card_token: nil, user_document: nil, value: -20 } }

      assert_response :unprocessable_entity
      assert_equal({
                     'credit_card_token' => ['can\'t be blank'],
                     'user_document' => ['can\'t be blank'],
                     'value' => ['must be greater than or equal to 0.1']
                   }, response.parsed_body)
    end
  end

  test 'updates user infos' do
    UserInfo.delete_all

    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: 'token222', user_document: '222999', value: 10 } }

    put api_v1_user_info_path(UserInfo.last), params: { user_info: { user_document: '000222111000' } }

    assert_response :success
    assert_equal({
                   'user_document' => '000222111000',
                   'credit_card_token' => 'token222',
                   'value' => 10
                 }, response.parsed_body)
  end

  test 'returns json with errors if cant update' do
    info = user_infos(:one)
    put api_v1_user_info_path(info), params: { user_info: { user_document: nil } }

    assert_response :unprocessable_entity
    assert_equal({
                   'user_document' => ['can\'t be blank']
                 }, response.parsed_body)
  end

  test 'returns 404 if user info isnt found on update' do
    put api_v1_user_info_path(129932813812), params: { user_info: { user_document: nil } }

    assert_response :not_found
  end

  test 'destroy an user info' do
    assert_difference('UserInfo.count', -1) do
      info = user_infos(:one)

      delete api_v1_user_info_path(info)

      assert_response :success
    end
  end
end
