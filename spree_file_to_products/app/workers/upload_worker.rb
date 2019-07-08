require 'sidekiq-status'

class UploadWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  include Constants::FileToProductsConstants

  sidekiq_options retry: false

  def perform(file, content_type)
    result = Spree::FileToProducts::ProductsUploader.upload_products_from_file(
      file: file, content_type: content_type
    )

    store result: result.to_json
  end
end
