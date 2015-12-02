class Record < ActiveRecord::Base
  include CryptoHelper

  belongs_to        :repository
  after_initialize  :decode
  attr_accessor     :iv, :file_name, :size, :token

  validates :file_name, presence: true, format: { with: /\A[\w\d]+\.\w{1,10}\z/, message: 'Not a valid file_name' }, length: { minimum: 3, maximum: 100 }
  validates :token_enc, uniqueness: true

  def decrypt_data(master_key)

    if master_key.nil? then raise SecurityError, 'Master key not available' end

    self.size = decrypt_aes_256(iv, master_key, size_enc)
    self.file_name = decrypt_aes_256(iv, master_key, file_name_enc)

  end

  def encrypt_data(master_key)
    self.iv_enc = b64_encode(iv)
    self.size_enc = encrypt_aes_256(iv, master_key, size)
    self.file_name_enc = encrypt_aes_256(iv, master_key, file_name)
  end

  private
  def decode
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end
  end
end
