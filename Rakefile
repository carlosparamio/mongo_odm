require 'rubygems'
require 'rake'

## gem building
require File.dirname(__FILE__) + "/lib/mongo_odm/version.rb"
if Gem.available? 'jeweler'
  require 'bundler'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "mongo_odm"
    gemspec.summary = "mongo_odm is a flexible persistence module for any Ruby class to MongoDB."
    gemspec.description = "mongo_odm is a flexible persistence module for any Ruby class to MongoDB."
    gemspec.email = "carlos@evolve.st"
    gemspec.homepage = "http://github.com/carlosparamio/mongo_odm"
    gemspec.authors = ["Carlos Paramio"]
    gemspec.files =  FileList["[A-Z]*", "{lib,spec}/**/*"]
    gemspec.version = MongoODM::VERSION
    bundle = Bundler::Definition.from_gemfile('Gemfile')
    bundle.dependencies.each do |dependency|
      if dependency.groups.include?(:default)
        gemspec.add_dependency(dependency.name, dependency.requirement.to_s)
      elsif dependency.groups.include?(:development)
        gemspec.add_development_dependency(dependency.name, dependency.requirement.to_s)
      end
    end
  end
  Jeweler::GemcutterTasks.new
else
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end

## rspec tasks
if Gem.available? 'rspec'
  require "rspec"
  require "rspec/core/rake_task"
  desc "Run all specs"
  Rspec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
  end
  
  ## rcov task
  if Gem.available? 'rcov'
    require 'rcov/rcovtask'
    Rspec::Core::RakeTask.new(:rcov) do |spec|
      spec.pattern = "spec/**/*_spec.rb"
      spec.rcov = true
    end
  end
else
  puts "WARNING: Install rspec to run tests"
end

## yard task
if Gem.available? 'yard'
  require 'yard'
  YARD::Rake::YardocTask.new do |yard|
    docfiles = FileList['lib/**/*.rb']
    yard.files = docfiles
    yard.options = ["--no-private"]
  end
end

task :release => :build do
  puts "Tagging #{MongoODM::VERSION}..."
  system "git tag -a #{MongoODM::VERSION} -m 'Release #{MongoODM::VERSION}'"
  puts "Pushing to Github..."
  system "git push --tags"
  puts "Pushing to Gemcutter..."
  system "gem push pkg/mongo_odm-#{MongoODM::VERSION}.gem"
end

## default task
task :default => :spec