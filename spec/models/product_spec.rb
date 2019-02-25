require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'is valid with all required attributes' do
      category = Category.new(name: 'transport')
      product = Product.new(
        name: 'boat',
        price: 444,
        quantity: 222,
        category: category
      )
      expect(product).to be_valid
    end
    it 'is not valid without a name' do
      category = Category.new(name: 'transport')
      product = Product.new(
        name: nil,
        price: 444,
        quantity: 222,
        category: category
      )
      expect(product).to_not be_valid
    end
    # nil passes, empty string does not
    it 'is not valid without a price' do
      category = Category.new(name: 'transport')
      product = Product.new(
        name: 'boat',
        price: '',
        quantity: 222,
        category: category
      )
      expect(product).to_not be_valid
    end
    it 'is not valid without a quanity' do
      category = Category.new(name: 'transport')
      product = Product.new(
        name: 'boat',
        price: 444,
        quantity: nil,
        category: category
      )
      expect(product).to_not be_valid
    end
    it 'is not valid without a category' do
      category = Category.new(name: 'transport')
      product = Product.new(
        name: 'boat',
        price: 444,
        quantity: nil,
        category: nil
      )
      expect(product).to_not be_valid
    end
  end
end