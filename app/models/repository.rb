class Repository < ActiveRecord::Base
  include CryptoHelper
  include AuditHelper
  include ActiveModel::Validations

  # Attributes
  has_secure_password
  has_many          :records
  attr_accessor     :title, :description, :master_key, :iv

  # Callbacks
  before_save       :encrypt_data
  before_destroy    :before_destroy
  after_initialize  :setup

  # Validations
  validates :title, presence: true, format: { with: /\A[ \d\w!,\.]+\z/, message: 'Only alphabetical characters are allowed.' }, length: { minimum: 1, maximum: 100 }
  validates :description, format: { with: /\A[\s\d\w!?\.\-_,()\{}\[\]\*\$\+=@"'#]*\z/, message: 'Illegal characters found.' }, length: { maximum: 1000 }
  validates :token, uniqueness: true
  validates :password, password_strength: {min_entropy: 10, use_dictionary: true, min_word_length: 6}

  def decrypt_data

    raise SecurityError, 'Master key not available' if master_key.nil?

    self.title = decrypt_aes_256(iv, master_key, title_enc)
    self.description = decrypt_aes_256(iv, master_key, description_enc)
  end

  def encrypt_master_key
    key = pbkdf2(iv, self.password)
    self.master_key_enc = encrypt_aes_256(iv, key, master_key)
  end

  def decrypt_master_key(password)
    key = pbkdf2(iv, password)
    self.master_key = decrypt_aes_256(iv, key, master_key_enc)
  end

  def days_to_deletion
    (self.deleted_at - DateTime.now).to_i
  end

  def setup
    if iv_enc.present?
      self.iv = b64_decode(iv_enc)
    end

    if token.nil? # Repository is created using new
      self.iv = generate_iv
      self.token = generate_token
      self.master_key = generate_key
      self.created_at = DateTime.now
      self.deleted_at = DateTime.now >> 1   # Add 1 month
    end
  end

  def generate_password
    pass = generate_secure_password
    self.password = pass
    self.password_confirmation = pass
  end

  private
  def encrypt_data
    self.iv_enc = b64_encode(iv)
    self.title_enc = encrypt_aes_256(iv, master_key, title)
    self.description_enc = encrypt_aes_256(iv, master_key, description)
  end

  def before_destroy
    Record.destroy_all "repositories_id = #{id}"
  end
end
