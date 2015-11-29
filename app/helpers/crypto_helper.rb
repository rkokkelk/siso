require 'base64'

module CryptoHelper

  MODE = :CBC
  KEY_SIZE = 256
  PBKDF_ROUNDS = 10000

  def encrypt_aes_256(iv, key, data)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.encrypt
    cipher.iv = iv
    cipher.key = key

    encrypt = cipher.update(data) + cipher.final
    encode = b64_encode encrypt
    return encode
  end

  def decrypt_aes_256(iv, key, encoded)
    cipher = OpenSSL::Cipher::AES.new(KEY_SIZE, MODE)

    cipher.decrypt
    cipher.iv = iv
    cipher.key = key

    encrypted = b64_decode encoded
    plain = cipher.update(encrypted) + cipher.final
    return plain
  end

  def pbkdf2(iv, pass)
    digest = OpenSSL::Digest::SHA256.new
    p = OpenSSL::PKCS5.pbkdf2_hmac(pass, iv, PBKDF_ROUNDS, digest.digest_length, digest)

    #ToDo: verify why only works with 2 iterations
    #pbkdf = PBKDF2.new do |p|
    #  p.password = password
    #  p.salt = iv
    #  p.iterations = PBKDF_ROUNDS
    #  p.key_length = KEY_SIZE
    #end
    return p
  end

  def b64_encode(data)
    Base64.encode64(data).force_encoding('UTF-8')
  end

  def b64_decode(data)
    Base64.decode64(data)
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

end
