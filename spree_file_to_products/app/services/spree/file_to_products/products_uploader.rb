module Spree
  module FileToProducts
    class ProductsUploader
      include Constants::FileToProductsConstants

      def self.upload_products_from_file(file:, content_type:)
        parser = Parser::ParserFactory.build(content_type)
        parsing_result = parser.parse(file)

        parsing_result[SUCCESS_STATUS] ? upload_products(parser.products) : parsing_result
      end

      def self.upload_products(products)
        uploading_result = products.map do |product_info|
          product = FileToProducts::Product.new(product_info)
          product.save
        end

        bad = uploading_result.select { |r| r[ERROR_STATUS] }
        good = uploading_result.select { |r| r[SUCCESS_STATUS] }

        finally_status = good.any? ? SUCCESS_STATUS : ERROR_STATUS

        {
          finally_status => Spree.t(:product_uploading_result, good: good.count, bad: bad.count, error: (bad.first || {})[:msg])
        }
      end
    end
  end
end
