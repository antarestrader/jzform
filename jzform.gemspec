Gem::Specification.new do |s|
  s.author = 'John F. Miller'
  s.date = File.ctime('Version')
  s.add_dependency('haml', '>= 2.0.0')
  s.add_dependency('nokogiri', '>= 1.1.0')
  s.description = File.read('About')
  s.email = 'support@antarestrader.com'
  s.extra_rdoc_files = ['README.textile']
  s.files = Dir['lib/**/*'] + Dir['spec/**/*'] +
    ['About','Todo','License','Rakefile','README.textile','History','Version']
  s.has_rdoc = true
  #s.homepage = 'http://???'
  s.name = 'jzform'
  s.summary = 'Builds user input forms based on a description of the needed data.'
  s.version = File.read('Version')
end