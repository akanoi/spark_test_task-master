module Spree
  module FileToProducts
    class Product
      include Constants::FileToProductsConstants

      FILE_ATTRS_TO_RENAME = {
        availability_date: :available_on,
      }.freeze

      FILE_ATTRS_TO_REJECT = %i[stock_total category].freeze

      def initialize(product_info)
        @product_info = product_info
        @product = Spree::Product.find_or_initialize_by(slug: @product_info[:slug])
      end

      def save
        prepare_product_info!

        @product.assign_attributes(@product_info.reject { |attr| FILE_ATTRS_TO_REJECT.include?(attr) })
        update_taxons_categories!

        @product.save!

        update_total_stock!

        { SUCCESS_STATUS => Spree.t(:success_operation) }
      rescue StandardError => e
        { ERROR_STATUS => e.message }
      end

      private

      def prepare_product_info!
        @product_info = @product_info.map do |attr, value|
          FILE_ATTRS_TO_RENAME[attr] ? [FILE_ATTRS_TO_RENAME[attr], value] : [attr, value]
        end.to_h

        @product_info[:shipping_category] = shipping_category
        @product_info[:price] = @product_info[:price].tr(',', '.').to_f
      end

      def shipping_category
        Spree::ShippingCategory.where(name: @product_info[:category]).first_or_create!
      end

      def update_taxons_categories!
        category = Spree::Taxon.where(name: @product_info[:category]).first_or_create!
        @product.taxons << category
      end

      def update_total_stock!
        stock_item = @product.master.stock_items.first_or_initialize(stock_location: StockLocation.first)

        stock_item.count_on_hand = @product_info[:stock_total]
        stock_item.save
      end
    end
  end
end
