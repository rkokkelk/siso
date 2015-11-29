class Repository < ActiveRecord::Base
  include MainHelper

  before_save   :encrypt_data
  attr_accessor :title_clear, :description_clear, :master_key_clear

  def encrypt_data
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)

    cipher.encrypt
    cipher.iv = self.iv
    cipher.key = self.master_key_clear

    self.title = encrypt_AES_256(self.iv, self.master_key_clear, title)
    self.description = encrypt_AES_256(self.iv, self.master_key_clear, description)
  end

end
