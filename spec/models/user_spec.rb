require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    # validation specs:
    # 1: must have password
    # 2: must have password_confirmation fields
    # 3: emails must be unique
    # 4: emails must not be case sensitive
    # 5-7: email, first name, and last name must be present
    it 'is valid with all required attributes' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: 'juliarom@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      expect(user).to be_valid
    end
    it 'is not valid without password' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: 'juliarom@gmail.com',
        password: nil,
        password_confirmation: 'testtest'
      )
      expect(user).to_not be_valid
    end
    it 'is not valid without password comfirmation' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: 'juliarom@gmail.com',
        password: 'testtest',
        password_confirmation: ''
      )
      expect(user).to_not be_valid
    end
    it 'is not valid without a unique email' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: 'juliarom@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      user.save
      user2 = User.new(
        first_name: 'Nicole',
        last_name: 'Syd',
        email: 'juliarom@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      user2.save
      expect(user2).to_not be_valid
    end
    it 'is valid when email is case insensitive ' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: 'JULIAROM@GmAiL.COm',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      expect(user).to be_valid
    end
    it 'is not valid when email is ommitted ' do
      user = User.new(
        first_name: 'Ju',
        last_name: 'Rom',
        email: '',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      expect(user).to_not be_valid
    end
    it 'is not valid when first name is ommitted ' do
      user = User.new(
        first_name: '',
        last_name: 'Rom',
        email: 'julia@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      expect(user).to_not be_valid
    end
    it 'is not valid when last name is ommitted ' do
      user = User.new(
        first_name: 'Julia',
        last_name: '',
        email: 'julia@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      expect(user).to_not be_valid
    end
    it 'is not valid when password is less than 6 characters ' do
      user = User.new(
        first_name: 'Julia',
        last_name: '',
        email: 'julia@gmail.com',
        password: 'test',
        password_confirmation: 'test'
      )
      expect(user).to_not be_valid
    end
  end

  describe '.authenticate_with_credentials' do
    # examples for this class method here
    it 'is valid when a existing email is provided ' do
      user = User.new(
        first_name: 'Julia',
        last_name: 'Rom',
        email: 'julia@gmail.com',
        password: 'testtest',
        password_confirmation: 'testtest'
      )
      user.save
      user2 = User.authenticate_with_credentials(user.email, user.password)
      expect(user).to eq(user2)
    end
  end
end
