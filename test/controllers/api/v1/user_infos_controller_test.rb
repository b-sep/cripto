# frozen_string_literal: true

require 'test_helper'

class Api::V1::UserInfosControllerTest < ActionDispatch::IntegrationTest
  test 'gets user infos list' do
    get api_v1_user_infos_path

    assert_response :success
    assert_equal([
      {
        'user_document' => 'MzI5NDU0MTA1ODM=',
        'credit_card_token' => 'eHl6NDU2',
        'value' => 1000.10
      },
      {
        'user_document' => 'MzYxNDA3ODE4MzM=',
        'credit_card_token' => 'YWJjMTIz',
        'value' => 890.0
      }
    ], response.parsed_body)
  end

  test 'get user infos' do
    get api_v1_user_info_path(user_infos(:one))

    assert_response :success

    assert_equal({
                   'user_document' => 'MzYxNDA3ODE4MzM=',
                   'credit_card_token' => 'YWJjMTIz',
                   'value' => 890.0
                 }, response.parsed_body)
  end

  test 'returns 404 if user info isnt found' do
    get api_v1_user_info_path('invalid')

    assert_response :not_found
  end

  test 'creates an user info' do
    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: 'token222', user_document: '222999', value: 10 } }

    assert_response :created
    assert_equal({
                   'user_document' => '222999',
                   'credit_card_token' => 'token222',
                   'value' => 10
                 }, response.parsed_body)
  end

  test 'returns json with errors if params are invalid' do
    post api_v1_user_infos_path,
         params: { user_info: { credit_card_token: nil, user_document: nil, value: -20 } }

    assert_response :unprocessable_entity
    assert_equal({
                   'credit_card_token' => ['can\'t be blank'],
                   'user_document' => ['can\'t be blank'],
                   'value' => ['must be greater than or equal to 0.1']
                 }, response.parsed_body)
  end

  test 'updates user infos' do
    info = user_infos(:one)

    put api_v1_user_info_path(info), params: { user_info: { user_document: '000222111000' } }

    assert_response :success
    assert_equal({
                   'user_document' => '000222111000',
                   'credit_card_token' => info.credit_card_token,
                   'value' => info.value
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
    info = user_infos(:one)

    delete api_v1_user_info_path(info)

    assert_response :success
  end
end
