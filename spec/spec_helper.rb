require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||='test'
  unless defined?(Rails)
      require File.dirname(__FILE__) + "/../config/environment"
  end
  
  require 'rspec/rails'
  
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
  
  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
  
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    
    def test_sign_in(user)
      controller.sign_in(user)
    end
    
    def integration_sign_in(user)
      visit signin_path
      fill_in :email,    :with => user.email
      fill_in :password, :with => user.password
      click_button
    end
    
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  
    ### Part of a Spork hack. See http://bit.ly/arY19y
    # Emulate initializer set_clear_dependencies_hook in
    # railties/lib/rails/application/bootstrap.rb
    ActiveSupport::Dependencies.clear
    
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require File.expand_path("../../config/routes", __FILE__)
end