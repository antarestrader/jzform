require 'rubygems'
require 'rake/rdoctask'
require 'spec/rake/spectask'

include FileUtils

tasks_path = File.join(File.dirname(__FILE__), "lib", "tasks")
rake_files = Dir["#{tasks_path}/*.rake"]
rake_files.each{|rake_file| load rake_file }

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['-c','-f specdoc']
end

desc 'Default: run spec examples'
task :default => 'spec'