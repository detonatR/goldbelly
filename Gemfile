source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', '~> 6.1.4', '>= 6.1.4.4'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 4.0.1"
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem "shoulda-matchers"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
