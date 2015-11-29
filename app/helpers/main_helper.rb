require 'base64'

module MainHelper

  def encrypt_AES_256(iv, key, data)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)

    cipher.encrypt
    cipher.iv = iv
    cipher.key =key

    encrypt = cipher.update(data) + cipher.final
    return Base64.encode64(encrypt).force_encoding('UTF-8')
  end

  def decrypt_AES_256(iv, key, encoded)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)

    cipher.decrypt
    cipher.iv = iv
    cipher.key =key

    encrypted = Base64.decode64(encoded)

    plain = cipher.update(encrypted) + cipher.final
    return plain
  end

end
