require 'base64'

module CryptoHelper
  PBKDF_ROUNDS = 20_000

  def encrypt_aes_256(iv, key, data, encode = true, auth_data = '')
    # Empty data cannot be encrypted, so return
    return data if data.nil? || data.empty?

    cipher = OpenSSL::Cipher.new 'aes-256-gcm'
    cipher.encrypt

    cipher.key = key
    cipher.iv = iv
    cipher.auth_data = auth_data

    encrypt = cipher.update(data) + cipher.final
    auth_encrypt = cipher.auth_tag + encrypt
    encode ? b64_encode(auth_encrypt) : auth_encrypt
  end

  def decrypt_aes_256(iv, key, data, encode = true, auth_data = '')
    # Empty data cannot be decrypted, so return
    return data if data.nil? || data.empty?

    cipher = OpenSSL::Cipher.new 'aes-256-gcm'
    cipher.decrypt

    encrypted = encode ? b64_decode(data) : data
    auth = encrypted[0, 16]
    enc_data = encrypted[16..-1]

    cipher.key = key
    cipher.iv = iv
    cipher.auth_tag = auth
    cipher.auth_data = auth_data

    cipher.update(enc_data) + cipher.final
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

  def generate_secure_password(size = 8)
    result = ''
    valid_chars = 'abcdefghijklmnoqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890!@@#$%^&*()_+=-][<>:;{}?.,'.split(//)
    size.times do
      result += valid_chars[SecureRandom.random_number valid_chars.size]
    end
    result
  end
end