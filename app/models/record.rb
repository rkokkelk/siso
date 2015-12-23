class Record < ActiveRecord::Base
  include CryptoHelper
  include RecordsHelper

  # Attributes
  belongs_to        :repository
  attr_accessor     :iv, :file_name, :size

  # Callbacks
  after_initialize  :decode
  before_destroy    :destroy_file

  # Validations
  validates         :file_name, presence: true, format: { with: /\A[\w\d \-()_\.]+\.\w{1,10}\z/, message: 'Not a valid file_name' }, length: { minimum: 3, maximum: 100 }
  validates         :size, presence: true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates         :token, uniqueness: true

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
  def destroy_file
    remove_record token
  end

  def decode
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end
  end
end