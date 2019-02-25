class User < ActiveRecord::Base

    has_secure_password

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true, case_sensitive: false
    validates :password_digest, presence: true, :length => { :minimum => 6 }, confirmation: true

end
