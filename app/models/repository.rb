class Repository < ActiveRecord::Base
  include CryptoHelper

  before_save       :encrypt_data
  after_initialize  :decode
  attr_accessor     :title, :description, :master_key, :iv

  has_secure_password

  def decrypt_data

    if master_key.nil?
      raise SecurityError, 'Master key not available'
    end

    self.title = decrypt_aes_256(iv, master_key, title_enc)
    self.description = decrypt_aes_256(iv, master_key, description_enc)
  end

  def encrypt_master_key(password)
    key = pbkdf2(iv, password)
    self.master_key_enc = encrypt_aes_256(iv, key, master_key)
  end

  def decrypt_master_key(password)
    key = pbkdf2(iv, password)
    decrypt_aes_256(iv, key, master_key_enc)
  end

  private
  def encrypt_data

    self.iv_enc = b64_encode(iv)
    self.title_enc = encrypt_aes_256(iv, master_key, title)
    self.description_enc = encrypt_aes_256(iv, master_key, description)
  end

  def decode
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end
  end

end
