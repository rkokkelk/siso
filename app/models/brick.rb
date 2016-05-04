class Brick < ActiveRecord::Base

  validates         :token, uniqueness: true
end
