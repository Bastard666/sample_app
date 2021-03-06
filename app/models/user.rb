class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  
  has_many :active_relationships,   class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships,  class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :following, through: :active_relationships,  source: :followed
  # Source is facultative since followers is the plural of follower
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  # Saves user email in lower case
  before_save :downcase_email

  # Add an activation digest before cration
  before_create :create_activation_digest
  
  # Set for an encrypted password
  has_secure_password

  # email regex pattern
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Attributes validations
  validates :name,      presence: true, length: { maximum: 50 }
  validates :email,     presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password,  presence: true, length: { minimum: 6 }, allow_nil: true

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(token_type, token)
    digest = send("#{token_type}_digest") unless token_type.empty?
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #############################################
  ####### Authentication cookie methods #######
  #############################################
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # Forgets the persistent session of the user.
  def forget
    update_attribute :remember_digest, nil
  end

  ############################################
  ######## Account activation methods ########
  ############################################
  # Activate user
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Send activation mail for the user
  def send_activation_mail
    UserMailer.account_activation(self).deliver_now
  end

  ############################################
  ########## Password reset methods ##########
  ############################################
  # Create a password reset token
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Send activation mail for the user
  def send_password_reset_mail
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if the password has expired
  def password_reset_expired?
    reset_sent_at && (reset_sent_at < 2.hours.ago)
  end

  def reset_password(params)
    update_attributes(params.merge({ reset_digest: nil, reset_sent_at: nil }))
  end

  ############################################
  #### Following relationships management ####
  ############################################
  # Returns true if user is followed
  def following?(other_user)
    following.include?(other_user)
  end

  # Create the relationship to follow a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Destroy the relationship to unfollow a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #############################################
  ## Static methods for new token and digest ##
  #############################################
  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #############################################
  ## Private methods used before saving user ##
  #############################################
  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
    
    # Create an activation digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
