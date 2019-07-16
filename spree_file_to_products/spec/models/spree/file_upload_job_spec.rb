require 'rails_helper'

RSpec.describe Spree::FileUploadJob, type: :model do
  let(:file) { fixture_file_upload(File.join(fixture_path, 'products_with_empty_lines.csv'), 'text/csv') }
  let(:bad_file) { fixture_file_upload(File.join(fixture_path, 'bad_file_type.txt'), 'text') }

  let(:exist_job) do
    id = subject.class.new_job(file)
    subject.class.find(id)
  end

  it 'is create new job' do
    subject.class.new_job(file)

    expect(subject.class.count).to be(1)
  end

  it 'is bad validation for bad file' do
    validation = subject.class.new_job(bad_file)

    expect(validation.values.first).to eql(Spree.t(:unsupported_file_type, types: Spree::FileToProducts::ProductsUploader::SUPPORTED_FILE_TYPES.join(', ')))
  end

  it 'is perform async job' do
    subject.class.new_job(file)

    expect(subject.class.first.worker_id).not_to be_empty
  end

  it 'is set status for exist job' do
    exist_job.set_status(success: 'test message')

    expect(exist_job.status).to(eql('success')) && expect(exist_job.msg).to(eql('test message'))
  end
end
