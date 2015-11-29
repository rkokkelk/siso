require 'base64'

module CryptoHelper

  MODE = :CBC
  KEY_SIZE = 256

  def encrypt_aes_256(iv, key, data)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.encrypt
    cipher.iv = iv
    cipher.key =key

    encrypt = cipher.update(data) + cipher.final
    Base64.encode64(encrypt).force_encoding('UTF-8')
  end

  def decrypt_aes_256(iv, key, encoded)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.decrypt
    cipher.iv = iv
    cipher.key =key

    encrypted = Base64.decode64(encoded)
    cipher.update(encrypted) + cipher.final
  end

  def generate_iv
    SecureRandom.hex 16
  end

  def generate_token
    SecureRandom.hex 16
  end

  def generate_key
    SecureRandom.random_bytes 32
  end

end
