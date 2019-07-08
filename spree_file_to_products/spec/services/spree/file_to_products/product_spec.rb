require 'rails_helper'

RSpec.describe Spree::FileToProducts::Product do
  subject(:product) { Spree::FileToProducts::Product }

  let(:product_info) do
    parser = Spree::FileToProducts::Parser::CSVParser.new
    parser.parse('spec/fixtures/products_with_empty_lines.csv')
    parser.products.first
  end

  it 'should be create product' do
    product.new(product_info).save

    expect(Spree::Product.all.count).to eql(1)
  end

  it 'should not create duplicate' do
    2.times { |_| product.new(product_info).save }

    expect(Spree::Product.all.count).to eql(1)
  end


end