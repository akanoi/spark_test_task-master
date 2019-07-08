module Spree
  module FileToProducts
    module Parser
      require 'smarter_csv'

      class CSVParser
        include Constants::FileToProductsConstants

        attr_reader :products

        def parse(file)
          @products = SmarterCSV.process(file, options)

          { SUCCESS_STATUS => Spree.t(:success_operation) }
        rescue StandardError => e
          { ERROR_STATUS => e.message }
        end

        def options
          {
            required_headers: REQUIRED_PRODUCT_FIELDS,
            unique_headers: true,
            col_sep: CSV_FILE_SEPARATOR,
          }
        end
      end
    end
  end
end
