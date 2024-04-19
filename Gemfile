source "https://rubygems.org"
gemspec

gem "minitest", "~> 5.11"
gem "minitest-rg", "~> 5.3"
gem "rake", "~> 13.0"
gem "rubocop", "1.60.2"
gem "rubocop-minitest", "0.34.5"
gem "rubocop-packaging", "0.5.2"
gem "rubocop-performance", "1.20.2"
gem "rubocop-rake", "0.6.0"
gem "rubocop-sorbet"

gem "sorbet-runtime"

group :test, :development do
  gem "pry-byebug"
  gem "rspec-sorbet"
  gem "sorbet"
  gem "tapioca", require: false
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
  end
end
