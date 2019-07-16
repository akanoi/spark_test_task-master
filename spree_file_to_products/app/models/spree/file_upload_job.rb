module Spree
  class FileUploadJob < ApplicationRecord
    include Constants::FileToProductsConstants

    has_one_attached :products_file

    enum status: { active: 0, success: 1, error: 2 }

    after_create :start

    def self.new_job(file)
      job = new

      validation = Spree::FileToProducts::FileToProductsHelper.file_validation(file.tempfile, file.content_type)
      return validation if validation[ERROR_STATUS]

      job.products_file.attach(file)

      job.save

      job.id
    end

    def start
      worker_id = UploadWorker.perform_async(id)
      update_attributes(worker_id: worker_id)
    end

    def set_status(to_set_status, to_set_msg = nil)
      status = !to_set_status.is_a?(Hash) || to_set_status.keys.first == :notice ? :active : to_set_status.keys.first

      msg = to_set_status[status] if to_set_status.is_a?(Hash)
      msg ||= to_set_msg

      update_attributes(status: status, msg: msg)
    end
  end
end
