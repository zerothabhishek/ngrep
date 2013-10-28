#require "bundler/gem_tasks"

desc "Run all tests"
task :test do
	test_dir = File.expand_path('../test', __FILE__)
	test_scripts = Dir["#{test_dir}/*.rb"]
	test_scripts.each do |test_script|
		require test_script
	end
end
