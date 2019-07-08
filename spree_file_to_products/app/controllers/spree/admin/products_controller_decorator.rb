module SpreeFileToProducts
  module Admin
    module ProductsControllerDecorator
      include Constants::FileToProductsConstants

      def upload_products_from_file
        if products_file_present?
          validation_result = Spree::FileToProducts::FileToProductsHelper.file_validation(products_file.tempfile, products_file.content_type)

          if validation_result[ERROR_STATUS]
            flash.now[ERROR_STATUS] = validation_result[ERROR_STATUS]
            return
          end

          upload_worker_id = UploadWorker.perform_async(products_file.tempfile.path, products_file.content_type)
          session[:upload_worker_id] = upload_worker_id

          redirect_to admin_products_path, flash: { SUCCESS_STATUS => Spree.t(:product_uploading_started) }
        end
      end

      def index
        session[:return_to] = request.url

        worker_id = session[:upload_worker_id]
        if worker_id && worker_finished?(worker_id)
          result = worker_result(worker_id)
          session[:upload_worker_id] = nil

          path = result[:error] ? upload_products_from_file_admin_products_path : admin_products_path
          redirect_to path, flash: result

          return
        elsif worker_id
          flash.now[:notice] = Spree.t(:product_uploading_in_process)
        end

        respond_with(@collection)
      end

      private

      def worker_finished?(worker_id)
        Sidekiq::Status::get_all(worker_id)['result']
      end

      def worker_result(worker_id)
        JSON.parse(Sidekiq::Status::get_all(worker_id)['result'], symbolize_names: true)
      end

      def products_file_present?
        params.dig(:products, :products_file)
      end

      def products_file
        params.dig(:products, :products_file)
      end

    end
  end
end

Spree::Admin::ProductsController.prepend SpreeFileToProducts::Admin::ProductsControllerDecorator
