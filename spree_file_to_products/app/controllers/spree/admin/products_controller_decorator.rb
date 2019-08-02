module SpreeFileToProducts
  module Admin
    module ProductsControllerDecorator

      def self.prepended(base)
        base.before_action :check_file_upload, only: :index
      end

      def upload_products_from_file
        if products_file_present?
          creating_job_id = Spree::FileUploadJob.new_job(products_file)
          unless creating_job_id.is_a?(Integer)
            flash.now[:error] = creating_job_id[:error]
            return
          end

          session[:upload_job_id] = creating_job_id

          redirect_to admin_products_path, flash: { success: Spree.t(:product_uploading_started) }
        end
      end

      private

      def check_file_upload
        job = begin
          Spree::FileUploadJob.find(session[:upload_job_id])
        rescue ActiveRecord::RecordNotFound => _error
          nil
        end

        if job&.status == 'active'
          flash.now[:notice] = Spree.t(:product_uploading_in_process)
        elsif job
          session[:upload_job_id] = nil

          path = job.status == :error ? upload_products_from_file_admin_products_path : admin_products_path
          redirect_to path, flash: { job.status => job.msg }

          job.destroy

          return
        end
      end

      def products_file
        params.dig(:products, :products_file)
      end

      alias products_file_present? products_file
    end
  end
end

Spree::Admin::ProductsController.prepend SpreeFileToProducts::Admin::ProductsControllerDecorator
