require 'rails_helper'

RSpec.describe 'Upload Products from file', type: :feature, js: true do
  context 'as admin user' do
    stub_authorization!

    context 'upload products from file' do
      before do
        visit spree.upload_products_from_file_admin_products_path

        expect(page).to have_content(/CHOOSE FILE/i)
      end

      it 'launches product upload' do
        attach_file(File.join(fixture_path, 'products_with_empty_lines.csv'))
        find_button(class: /btn-success/).click

        page.has_current_path?(spree.admin_products_path) && \
          expect(page).to(have_content(Spree.t(:product_uploading_in_process)))
      end

      it 'shows file type validation error' do
        attach_file(File.join(fixture_path, 'bad_file_type.txt'))
        find_button(class: /btn-success/).click

        page.has_current_path?(spree.upload_products_from_file_admin_products_path) && \
          expect(page).to(have_content(Spree.t(:unsupported_file_type, types: Spree::FileToProducts::ProductsUploader::SUPPORTED_FILE_TYPES.join(', '))))
      end
    end
  end
end
