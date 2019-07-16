module SpreeFileToProducts
  module Admin
    module ProductsControllerDecorator
      include Constants::FileToProductsConstants

      def upload_products_from_file
        if products_file_present?
          creating_job_id = Spree::FileUploadJob.new_job(products_file)
          unless creating_job_id.is_a?(Integer)
            flash.now[ERROR_STATUS] = creating_job_id[ERROR_STATUS]
            return
          end

          session[:upload_job_id] = creating_job_id

          redirect_to admin_products_path, flash: { SUCCESS_STATUS => Spree.t(:product_uploading_started) }
        end
      end

      def index
        session[:return_to] = request.url

        job = begin
                Spree::FileUploadJob.find(session[:upload_job_id])
              rescue ActiveRecord::RecordNotFound => _error
                nil
              end

        if job && job.status == 'active'
          flash.now[:notice] = Spree.t(:product_uploading_in_process)
        elsif job
          session[:upload_job_id] = nil

          path = job.status == :error ? upload_products_from_file_admin_products_path : admin_products_path
          redirect_to path, flash: { job.status => job.msg }

          job.destroy

          return
        end

        respond_with(@collection)
      end

      private

      def products_file
        params.dig(:products, :products_file)
      end

      alias products_file_present? products_file
    end
  end
end

Spree::Admin::ProductsController.prepend SpreeFileToProducts::Admin::ProductsControllerDecorator
