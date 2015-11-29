class Repository < ActiveRecord::Base
  include CryptoHelper

  before_save       :encrypt_data
  after_initialize  :decode
  attr_accessor     :title, :description, :master_key, :iv

  has_secure_password

  def decrypt_data
    self.title = decrypt_aes_256(iv, master_key, title_enc)
    self.description = decrypt_aes_256(iv, master_key, description_enc)
  end

  private
  def encrypt_data

    self.iv_enc = b64_encode(iv)
    self.title_enc = encrypt_aes_256(iv, master_key, title)
    self.description_enc = encrypt_aes_256(iv, master_key, description)
  end

  def decode
    if self.iv_enc
      self.iv = b64_decode(self.iv_enc)
    end
  end

end
