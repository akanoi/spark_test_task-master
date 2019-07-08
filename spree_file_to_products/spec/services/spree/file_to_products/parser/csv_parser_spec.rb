require 'rails_helper'

RSpec.describe Spree::FileToProducts::Parser::CSVParser do
  it 'should be parsed 3 uniq products' do
    subject.parse('spec/fixtures/products_with_empty_lines.csv')

    expect(subject.products.count).to eql(3)
  end

  it 'should be raise error for products without required key' do
    result = subject.parse('spec/fixtures/products_without_required_keys.csv')

    expect(result.values.first).to eql('ERROR: missing headers: name')
  end

end
