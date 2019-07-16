module Spree
  module FileToProducts
    class FileToProductsHelper
      def self.clear_file(file)
        filepath = file.respond_to?(:path) ? file.path : file

        File.delete(filepath) if File.exist?(filepath)
      end

      def self.file_validation(file, content_type)
        unless File.exist?(file)
          return { error: Spree.t(:products_file_not_found) }
        end

        unless Spree::FileToProducts::ProductsUploader::SUPPORTED_FILE_TYPES.include?(content_type)
          return { error: Spree.t(:unsupported_file_type, types: Spree::FileToProducts::ProductsUploader::SUPPORTED_FILE_TYPES.join(', ')) }
        end

        { success: Spree.t(:valid_products_file) }
      end

      def self.prepare_file(file)
        file.is_a?(String) ? StringIO.new(file) : file
      end
    end
  end
end
