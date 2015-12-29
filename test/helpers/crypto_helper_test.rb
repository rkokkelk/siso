require 'test_helper'

class CryptoHelperTest < ActiveSupport::TestCase
  include CryptoHelper

  data = 'foobar,foobar,!@#$%^&\\\'*)(_][}{|~`<.>/`'

  test 'PBKDF2 with random values' do
    iv = generate_iv
    data = generate_token
    key1 = pbkdf2(iv, data)
    key2 = pbkdf2(iv, data)

    assert_equal key1, key2
  end

  test 'AES-256 encryption with random values' do
    iv = generate_iv
    key = generate_key
    data = generate_token

    encrypt = encrypt_aes_256(iv,key,data)
    decrypt = decrypt_aes_256(iv,key,encrypt)

    assert_equal data, decrypt
  end

  test 'AES-256 encryption with random values and no encoding' do
    iv = generate_iv
    key = generate_key
    data = generate_token

    encrypt = encrypt_aes_256(iv,key,data, false)
    decrypt = decrypt_aes_256(iv,key,encrypt, false)

    assert_equal data, decrypt
  end

  test 'Base64 encoding with static values' do

    encode = b64_encode data
    plain = b64_decode encode

    assert_equal data, plain
  end

  test 'Base64 encoding with random values' do
    data = generate_token

    encode = b64_encode data
    plain = b64_decode encode

    assert_equal data, plain
  end

  test 'Password generate' do
    pass = generate_password
    assert_equal pass.size, 8

    pass = generate_password 20
    assert_equal pass.size, 20
  end
end
