module Spree
  module FileToProducts
    class ProductsUploader
      SUPPORTED_FILE_TYPES = %w[csv text/csv].freeze

      def self.upload_products_from_file(file:, content_type:)
        parser = Parser::ParserFactory.build(content_type)
        parsing_result = parser.parse(file)

        parsing_result[:success] ? upload_products(parser.products) : parsing_result
      end

      def self.upload_products(products)
        uploading_result = products.map do |product_info|
          product = FileToProducts::Product.new(product_info)
          product.save
        end

        bad = uploading_result.select { |r| r[:error] }
        good = uploading_result.select { |r| r[:success] }

        finally_status = good.any? ? :success : :error

        {
          finally_status => Spree.t(:product_uploading_result, good: good.count, bad: bad.count, error: (bad.first || {})[:msg])
        }
      end
    end
  end
end
