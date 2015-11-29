class Repository < ActiveRecord::Base
  include CryptoHelper

  before_save       :encrypt_data
  after_initialize  :decode
  attr_accessor     :description, :master_key, :iv

  has_secure_password

  private
  def encrypt_data
    @iv_enc = b64_encode(@iv)
    #@title_enc = encrypt_aes_256(@iv, @master_key, @title)
    @description_enc = encrypt_aes_256(@iv, @master_key, @description)
  end

  def decrypt_data
    @title = encrypt_aes_256(@iv, @master_key, @title_enc)
    @description = encrypt_aes_256(@iv, @master_key, @description_enc)
  end

  def decode
    if @iv_enc
      @iv = b64_decode(@iv_enc)
    end
  end

end
