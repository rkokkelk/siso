class Audit < ActiveRecord::Base
  # Attributes
  belongs_to        :repository

  # Validations
  validates         :message, presence: true, format: { with: /\A[\w\d\s \-:\/()_\[\]\.]+\z/ }, length: { minimum: 1, maximum: 200 }
  validates         :token, presence: true
end
