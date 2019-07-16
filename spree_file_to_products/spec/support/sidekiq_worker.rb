require 'sidekiq/testing'

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
  config.before(:all) do
    Sidekiq::Testing.fake!

    Sidekiq::Worker.clear_all
  end
  config.before do
  end
end
