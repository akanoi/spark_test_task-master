module SpreeFileToProducts
  module Admin
    module ProductsControllerDecorator
      def upload_products_from_file; end
    end
  end
end

Spree::Admin::ProductsController.prepend SpreeFileToProducts::Admin::ProductsControllerDecorator
