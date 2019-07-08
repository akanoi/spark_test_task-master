module Spree
  module FileToProducts
    class FileToProductsHelper
      include Constants::FileToProductsConstants

      def self.clear_file(file)
        filepath = file.respond_to?(:path) ? file.path : file

        File.delete(filepath) if File.exist?(filepath)
      end

      def self.file_validation(file, content_type)
        unless File.exist?(file)
          return { ERROR_STATUS => Spree.t(:products_file_not_found) }
        end

        unless SUPPORTED_FILE_TYPES.include?(content_type)
          return { ERROR_STATUS => Spree.t(:unsupported_file_type, types: SUPPORTED_FILE_TYPES.join(', ')) }
        end

        { SUCCESS_STATUS => Spree.t(:valid_products_file) }
      end
    end
  end
end
