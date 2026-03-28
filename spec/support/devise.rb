RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.after(:each) { Warden.test_reset! }
end
