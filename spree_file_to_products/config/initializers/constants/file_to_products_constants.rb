module Constants
  module FileToProductsConstants
    ERROR_STATUS = :error
    SUCCESS_STATUS = :success

    SUPPORTED_FILE_TYPES = %w[csv text/csv].freeze
    CSV_FILE_SEPARATOR = ';'.freeze

    REQUIRED_PRODUCT_FIELDS = %i[name price category].freeze
  end
end
