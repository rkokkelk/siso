class Repository < ActiveRecord::Base
  include CryptoHelper

  before_save   :encrypt_data
  attr_accessor :title_clear, :description_clear, :master_key_clear

  def encrypt_data
    self.title = encrypt_aes_256(self.iv, self.master_key_clear, title)
    self.description = encrypt_aes_256(self.iv, self.master_key_clear, description)
  end

end
