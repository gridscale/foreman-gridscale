require File.expand_path('../engine', File.dirname(__FILE__))
namespace :test do
  desc 'Run the plugin unit test suite.'
  task :gridscale => ['db:test:prepare'] do
    test_task = Rake::TestTask.new('gridscale_test_task') do |t|
      t.libs << ['test', "#{ForemanGridscale::Engine.root}/test"]
      t.test_files = [
        "#{ForemanGridscale::Engine.root}/test/**/*_test.rb"
      ]
      t.verbose = true
      t.warning = false
    end

    Rake::Task[test_task.name].invoke
  end
end

namespace :gridscale do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_gridscale) do |task|
        task.patterns = ["#{ForemanGridscale::Engine.root}/app/**/*.rb",
                         "#{ForemanGridscale::Engine.root}/lib/**/*.rb",
                         "#{ForemanGridscale::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_gridscale'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:gridscale'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance do
    Rake::Task['test:gridscale'].invoke
    Rake::Task['gridscale:rubocop'].invoke
  end
end
