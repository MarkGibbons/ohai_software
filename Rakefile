desc 'runs style tests'
task style: []

desc 'runs unit tests'
task spec: []

desc 'runs integration tests'
task integration: []

desc 'runs style and unit tests'
task test: [:style, :spec]

desc 'runs all tests'
task default: :test

# rubocop
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.formatters = ['progress']
  t.options = ['-D']
  t.patterns = %w(
    attributes/*.rb
    recipes/*.rb
    libraries/**/*.rb
    resources/*.rb
    providers/*.rb
    spec/**/*.rb
    test/**/*.rb
    ./metadata.rb
    ./Berksfile
    ./Gemfile
    ./Rakefile
  )
end
task style: :rubocop


# foodcritic
require 'foodcritic'
require 'foodcritic/rake_task'

FoodCritic::Rake::LintTask.new(:foodcritic)
task style: :foodcritic


# testkitchen
begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue
  desc 'placeholder Test Kitchen task when plugins are missing'
  task 'kitchen:all' do
    puts 'test-kitchen plugins not installed; this is a placeholder task'
  end
end
task integration: 'kitchen:all'


# chefspec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:chefspec)

desc 'Generate ChefSpec coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:chefspec].invoke
end
task spec: :chefspec


