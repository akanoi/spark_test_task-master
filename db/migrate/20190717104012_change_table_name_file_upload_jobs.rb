class ChangeTableNameFileUploadJobs < ActiveRecord::Migration[5.2]
  def change
    rename_table :file_upload_jobs, :spree_file_upload_jobs
  end
end
