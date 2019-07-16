module Spree
  module FileToProducts
    module Parser
      require 'smarter_csv'

      class CSVParser
        CSV_FILE_SEPARATOR = ';'.freeze
        REQUIRED_PRODUCT_FIELDS = %i[name price category].freeze

        attr_reader :products

        def parse(file)
          @products = SmarterCSV.process(file, options)

          { success: Spree.t(:success_operation) }
        rescue StandardError => e
          { error: e.message }
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
