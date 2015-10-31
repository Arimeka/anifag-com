source 'https://rubygems.org'

ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

# DB adapter
gem 'pg'
gem 'migration_comments'

# Pagination
gem 'kaminari'

# Taggins
gem 'acts-as-taggable-on', '~> 3.4'

# File upload
gem 'paperclip', '~> 4.3'
gem 'aws-sdk', '~> 1.6'

# Auth
gem 'devise'

# HTML
# == Templates
gem 'haml-rails'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :assets do
  # CSS
  gem 'sass-rails', '~> 5.0'
  gem 'twitter-bootstrap-rails'
  gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
  gem 'autoprefixer-rails'

  # Wysiwyg
  gem 'tinymce-rails'

  # JS
  # == Server-side JS execution
  gem 'therubyracer'
  # == JS  compressor & minification tools
  gem 'uglifier', '>= 1.3.0'
  # == CoffeeScript
  gem 'coffee-rails', '~> 4.1.0'
  # == JQuery
  gem 'jquery-rails'
  # JSON API builder
  gem 'jbuilder', '~> 2.0'
  # Drug'n'Drop Upload
  gem 'dropzonejs-rails'
  # Templates
  gem 'hogan_assets'

  gem 'photoswipe-rails'
  gem 'videojs_rails'
  gem 'twitter-typeahead-rails'

  source 'https://rails-assets.org' do
    gem 'rails-assets-moment'
    gem 'rails-assets-bootstrap-tokenfield'
    gem 'rails-assets-Sortable'
    gem 'rails-assets-fotorama'
  end
end

group :development do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-rvm', '~> 0.1.0'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets', '~> 1.0.3'
  gem 'annotate'

  gem 'fog'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'faker'
  gem 'spring'
end

group :test do
  # TDD
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  # Test coverage
  gem 'simplecov', require: false
  # Fake data
  gem 'factory_girl_rails'
  # Fixtures cleaner
  gem 'database_cleaner'
  # HTTP stub
  gem 'webmock'
  gem 'sinatra'
end

