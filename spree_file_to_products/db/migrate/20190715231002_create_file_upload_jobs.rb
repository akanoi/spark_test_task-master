class CreateFileUploadJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_file_upload_jobs do |t|
      t.integer :status, default: 0
      t.string :msg
      t.string :worker_id

      t.timestamps
    end
  end
end
