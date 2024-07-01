source "https://rubygems.org"
gemspec

gem "rake", "~> 13.0"
gem "rubocop", "1.64.1"
gem "rubocop-packaging", "0.5.2"
gem "rubocop-performance", "1.21.1"
gem "rubocop-rake", "0.6.0"
gem "rubocop-rspec", "~> 3.0"
gem "rubocop-sorbet"

group :test, :development do
  gem "pry-byebug"
  gem "rspec-sorbet"
  gem "sorbet"
  gem "tapioca", require: false
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
  end
end
