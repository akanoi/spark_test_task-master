require 'rails_helper'

RSpec.describe Spree::FileToProducts::FileToProductsHelper do
  it 'should be clear file' do
    File.new('/tmp/test_file_to_delete.txt', 'w').close
    result = subject.class.clear_file('/tmp/test_file_to_delete.txt')

    expect(result).to eql(1) # If file real deleted
  end

  context 'file validation' do
    it 'should be fail if file not exist' do
      result = subject.class.file_validation('/tmp/fake_file', '')

      expect(result.values.first).to eql(Spree.t(:products_file_not_found))
    end

    it 'should be fail if file have bad type' do
      File.new('/tmp/bad_type_file.txt', 'w').close
      result = subject.class.file_validation('/tmp/bad_type_file.txt', 'text')
      File.delete('/tmp/bad_type_file.txt')

      expect(result.values.first).to eql(Spree.t(:unsupported_file_type, types: SUPPORTED_FILE_TYPES.join(', ')))
    end

    it 'should be pass if file good' do
      File.new('/tmp/good_file.csv', 'w').close
      result = subject.class.file_validation('/tmp/good_file.csv', 'text/csv')
      File.delete('/tmp/good_file.csv')

      expect(result.values.first).to eql(Spree.t(:valid_products_file))
    end

    it 'should be add to raw sting readline method' do
      raw_string = File.read(File.join(fixture_path, 'products_with_empty_lines.csv'))
      prepared_string = subject.class.prepare_file(raw_string)

      expect(prepared_string).to respond_to(:readline)
    end
  end
end