class Repository < ActiveRecord::Base
  include CryptoHelper
  include ActiveModel::Validations

  before_save       :encrypt_data
  after_initialize  :decode
  attr_accessor     :title, :description, :master_key, :iv

  has_secure_password

  validates :title, presence: true, format: { with: /\A[ \d\w!]+\z/, message: 'Only alphabetical characters are allowed.' }, length: { minimum: 1, maximum: 100 }
  validates :description, format: { with: /\A[ \d\w!]*\z/, message: 'Only alphabetical characters are allowed.' }, length: { maximum: 1000 }
  validates :token, uniqueness: true
  validates :password, password_strength: {min_entropy: 20, use_dictionary: true, min_word_length: 6}

  def decrypt_data

    if master_key.nil? then raise SecurityError, 'Master key not available' end

    self.title = decrypt_aes_256(iv, master_key, title_enc)
    if description_enc.empty?
      self.description = description_enc
    else
      self.description = decrypt_aes_256(iv, master_key, description_enc)
    end
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
    if description.empty?
      self.description_enc = description
    else
      self.description_enc = encrypt_aes_256(iv, master_key, description)
    end
  end

  def decode
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end
  end

end
