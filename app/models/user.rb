class User < ActiveRecord::Base

    has_secure_password

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true, case_sensitive: false, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password_digest, presence: true, :length => { :minimum => 6 }, confirmation: true

    def self.authenticate_with_credentials(email, password)
      user = User.find_by_email(email)
      if user && user.authenticate(password)
        user
      else
        nil
      end
    end

end
