source 'https://rubygems.org'

gem 'rake', '~> 10.4'
gem 'pry', '~> 0.10'
gem 'pry-byebug', '~> 3.1'
gem 'pry-rescue', '~> 1.4'
gem 'pry-stack_explorer', '~> 0.4'
gem 'berkshelf', '~> 3.3'
gem 'guard', '~> 2.12'
gem 'rubocop', '~> 0.31'
gem 'guard-rubocop', '~> 1.1'
gem 'foodcritic', '~> 4.0'
gem 'guard-foodcritic', '~> 1.1'
gem 'test-kitchen', '~> 1.4'
gem 'kitchen-vagrant', '~> 0.16'
gem 'chefspec', '~> 4.1'
gem 'guard-rspec', '~> 4.5'
gem 'ci_reporter_rspec', '~> 1.0'

# load local overrides
gemfile_dir = File.absolute_path(File.join('.', 'lib', 'gemfile'))
Dir.glob(File.join(gemfile_dir, '*.bundler')).each do |snippet|
  # rubocop:disable Lint/Eval
  eval File.read(snippet), nil, snippet
end
