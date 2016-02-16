class User < ActiveRecord::Base
  # Save user email in lower case
  before_save { self.email = email.downcase }

  # email regex pattern
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # Set for an encrypted password
  has_secure_password

  # Attributes validations
  validates :name,      presence: true, length: { maximum: 50 }
  validates :email,     presence: true, length: { maximum: 255 },
                          format: { with: VALID_EMAIL_REGEX },
                          uniqueness: { case_sensitive: false }
  validates :password,  presence: true, length: { minimum: 6 }

end
