# frozen_string_literal: true

module Cipher
  extend self

  SECRET = Rails.application.credentials.cipher_secret
  SALT_SIZE = 16

  def encrypt(data)
    salt = SecureRandom.bytes(SALT_SIZE)
    cipher.encrypt
    cipher.key = generate_key(salt)
    iv = cipher.random_iv

    "#{salt}#{iv}#{cipher.update(data) + cipher.final}"
  end

  def decrypt(encrypted_data)
    cipher.decrypt

    cipher.key = generate_key(encrypted_data.slice(0..15))
    # 16 throught 31 is the iv used to encrypt
    cipher.iv = encrypted_data.slice(SALT_SIZE..31)

    cipher.update(encrypted_data[SALT_SIZE * 2..]) + cipher.final
  end

  private

  def cipher
    @cipher ||= OpenSSL::Cipher.new('aria-256-ctr')
  end

  def generate_key(salt)
    hash = OpenSSL::Digest.new('SHA256')
    OpenSSL::KDF.pbkdf2_hmac(SECRET, salt:, iterations: 1000, length: hash.digest_length, hash:)
  end

  private_constant :SECRET
end
