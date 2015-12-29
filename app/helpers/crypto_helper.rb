require 'base64'

module CryptoHelper

  MODE = :CBC
  KEY_SIZE = 256
  PBKDF_ROUNDS = 20000

  def encrypt_aes_256(iv, key, data, encode=true)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.encrypt
    cipher.iv = iv
    cipher.key = key

    encrypt = cipher.update(data) + cipher.final
    encode ? b64_encode(encrypt) : encrypt
  end

  def decrypt_aes_256(iv, key, data, encode=true)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.decrypt
    cipher.iv = iv
    cipher.key = key

    encrypted = encode ? b64_decode(data) : data
    cipher.update(encrypted) + cipher.final
  end

  def pbkdf2(iv, pass)
    digest = OpenSSL::Digest::SHA256.new
    OpenSSL::PKCS5.pbkdf2_hmac(pass, iv, PBKDF_ROUNDS, digest.digest_length, digest)
  end

  def b64_encode(data)
    Base64.strict_encode64(data).force_encoding('UTF-8')
  end

  def b64_decode(data)
    Base64.strict_decode64(data)
  end

  def generate_iv
    SecureRandom.random_bytes 32
  end

  def generate_token
    SecureRandom.hex 16
  end

  def generate_key
    SecureRandom.random_bytes 32
  end

  def generate_password(size=8)
    result = ''
    valid_chars = 'abcdefghijklmnoqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890!@@#$%^&*()_+=-][<>:;{}?.,'.split(//);
    size.times do
      result += valid_chars[SecureRandom.random_number valid_chars.size]
    end
    result
  end

end
