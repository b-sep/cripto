# frozen_string_literal: true

require 'test_helper'

class CipherTest < ActiveSupport::TestCase
  test 'encrypt data' do
    data = '123.456.873-04'

    assert_not_equal(data, Cipher.encrypt(data))
  end

  test 'decrypt data' do
    data = '123.456.873-04'

    res = Cipher.encrypt(data)

    assert_equal(data, Cipher.decrypt(res))
  end
end
