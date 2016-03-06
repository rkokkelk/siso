class Record < ActiveRecord::Base
  include CryptoHelper
  include RecordsHelper

  # Attributes
  belongs_to        :repository
  attr_accessor     :iv, :file_name, :size

  # Callbacks
  after_initialize  :setup
  before_destroy    :destroy_file

  # Validations
  validates         :file_name, presence: true, format: { with: /\A[\w\d \-()_\.]+\.\w{1,10}\z/}, length: { minimum: 3, maximum: 100 }
  validates         :size, presence: true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 150000000}
  validates         :token, uniqueness: true

  def decrypt_data(master_key)

    raise SecurityError, 'Master key not available' if master_key.nil?

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
    begin
      remove_record token
    rescue IOError => e
      logger.error{"Error destroying record: #{e.message}"}
    end
  end

  def setup
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end

    if token.nil?
      self.iv = generate_iv
      self.token = generate_token
    end
  end
end