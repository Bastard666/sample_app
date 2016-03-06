source 'https://rubygems.org'

ruby '2.1.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',                    '4.2.2'
# Use ActiveModel has_secure_password
gem 'bcrypt',                   '3.1.10'
# Use faker to seed database
gem 'faker',                    '1.6.1'
# User will_paginate for resource lists pagination
gem 'will_paginate',            '3.1.0'
gem 'bootstrap-will_paginate',   '0.0.10'
# User carrierwave, mini_magick and fog to upload images in posts
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '4.4.0'
gem 'fog',                     '1.37.0'
# Use bootstrap
gem 'bootstrap-sass',           '3.3.6'
# Use SCSS for stylesheets
gem 'sass-rails',               '5.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',                 '2.5.3'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails',             '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails',             '4.0.3'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks',               '2.3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder',                 '2.2.3'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',                     '~> 0.4.0', group: :doc


# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3',      '1.3.11'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug',       '3.4.0'

  # Access an IRB console on exceptions page and /console in development
  gem 'rubysl-pty', :platforms => :ruby
  gem 'web-console',  '2.0.0.beta3', :platforms => :ruby

  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring',       '1.1.3'

  # Code coverage
  gem 'simplecov',    '0.11.2'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
  gem 'wdm',                '0.1.1' if Gem.win_platform?
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.3'
  gem 'puma',           '2.16.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
