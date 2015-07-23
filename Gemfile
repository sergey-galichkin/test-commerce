source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgres as the database for Active Record
gem 'pg', '~> 0.18.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use apartment for multi-tenant databases
gem 'apartment', '~> 1.0.1'

#bootstrap CSS
#gem 'bootstrap-sass'
# Devise is a flexible authentication solution for Rails based on Warden
gem 'devise', '~> 3.5.1'

# simple authorization solution for Rails which is decoupled from user roles
gem 'cancancan', '~> 1.12.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'slim-rails', '~> 3.0.1'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn', '~> 4.9.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Shim to load environment variables from .env into ENV in development.
gem 'dotenv-rails', '~> 2.0.2', :groups => [:development, :test]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'capybara', '~> 2.4.4'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'rspec-rails', '~> 3.2.3'
  gem 'factory_girl', '~> 4.5.0'
  gem 'rspec-expectations', '~> 3.2.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'faker', '~> 1.4.3'
end

# Deployment
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rvm', '~> 0.1.2'
gem 'capistrano-bundler', '~> 1.1.4'
gem 'capistrano-rails', '~> 1.1.3'
gem 'capistrano3-unicorn', '~> 0.2.1'
