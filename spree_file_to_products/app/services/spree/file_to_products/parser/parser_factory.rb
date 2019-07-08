module Spree
  module FileToProducts
    module Parser
      class ParserFactory
        def self.build(type)
          case type.to_s.downcase
          when 'csv', 'text/csv'
            CSVParser.new
          else
            raise StandardError, 'Unsupported products file type!'
          end
        end
      end
    end
  end
end
