require 'rails_helper'

RSpec.describe Spree::FileToProducts::Parser::ParserFactory do
  parser_factory = Spree::FileToProducts::Parser::ParserFactory

  it 'accept csv file type' do
    parser_factory.build(:csv).eql? Spree::FileToProducts::Parser::CSVParser
  end

  it 'accept text/csv file type' do
    parser_factory.build('text/csv').eql? Spree::FileToProducts::Parser::CSVParser
  end

  it 'other file types not supported' do
    expect { parser_factory.build('pdf') }.to raise_error(/unsupported products file type/i)
  end
end
