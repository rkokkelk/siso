class Record < ActiveRecord::Base
  include CryptoHelper

  belongs_to        :repository
  after_initialize  :decode
  attr_accessor     :iv, :file_name, :size, :token

  def decrypt_data(master_key)

    if master_key.nil? then raise SecurityError, 'Master key not available' end

    self.size = decrypt_aes_256(iv, master_key, size_enc)
    self.token = decrypt_aes_256(iv, master_key, token_enc)
    self.file_name = decrypt_aes_256(iv, master_key, file_name_enc)

  end

  def encrypt_data(master_key)
    self.iv_enc = b64_encode(iv)
    self.size_enc = encrypt_aes_256(iv, master_key, size)
    self.token_enc = encrypt_aes_256(iv, master_key, token)
    self.file_name_enc = encrypt_aes_256(iv, master_key, file_name)
  end

  private
  def decode
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end
  end
end
