# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, case_sensitive: false, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, length: { minimum: 6 }, confirmation: true

  def self.authenticate_with_credentials(email, password)
    stripped_email = email.strip.downcase
    user = User.find_by_email(stripped_email)
    user if user&.authenticate(password)
  end
end
