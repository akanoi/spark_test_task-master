require 'rails_helper'

RSpec.describe Spree::FileToProducts::Product do
  subject(:product) { described_class }

  let(:product_info) do
    parser = Spree::FileToProducts::Parser::CSVParser.new
    parser.parse('spec/fixtures/products_with_empty_lines.csv')
    parser.products.first
  end

  it 'is create product' do
    product.new(product_info).save

    expect(Spree::Product.all.count).to be(1)
  end

  it 'does not create duplicate' do
    2.times { |_| product.new(product_info).save }

    expect(Spree::Product.all.count).to be(1)
  end
end
