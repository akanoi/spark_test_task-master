require 'rails_helper'

RSpec.describe Spree::FileToProducts::Parser::ParserFactory do
  it 'accept csv file type' do
    subject.class.build(:csv).eql? Spree::FileToProducts::Parser::CSVParser
  end

  it 'accept text/csv file type' do
    subject.class.build('text/csv').eql? Spree::FileToProducts::Parser::CSVParser
  end

  it 'other file types not supported' do
    expect { subject.class.build('pdf') }.to raise_error(/unsupported products file type/i)
  end
end
