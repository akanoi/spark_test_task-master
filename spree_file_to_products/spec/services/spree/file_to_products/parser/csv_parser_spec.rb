require 'rails_helper'
require 'pry'

RSpec.describe Spree::FileToProducts::Parser::CSVParser do
  it 'should be parsed 3 uniq products' do
    csv_parser = Spree::FileToProducts::Parser::CSVParser.new
    csv_parser.parse('spec/fixtures/products_with_empty_lines.csv')

    expect(csv_parser.products.count).to eql(3)
  end

  it 'should be raise error for products without required key' do
    csv_parser = Spree::FileToProducts::Parser::CSVParser.new
    result = csv_parser.parse('spec/fixtures/products_without_required_keys.csv')

    expect(result.values.first).to eql('ERROR: missing headers: name')
  end

end
