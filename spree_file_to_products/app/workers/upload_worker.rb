require 'sidekiq-status'

class UploadWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  include Constants::FileToProductsConstants

  sidekiq_options retry: false

  def perform(job_id)
    job = Spree::FileUploadJob.find(job_id)
    return job unless job

    file = Spree::FileToProducts::FileToProductsHelper.prepare_file(job.products_file.download)
    content_type = job.products_file.content_type

    result = Spree::FileToProducts::ProductsUploader.upload_products_from_file(
      file: file, content_type: content_type
    )

    job.set_status(result)
  end
end
