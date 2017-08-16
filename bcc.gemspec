Gem::Specification.new do |s|
  s.name = 'bcc'
  s.version = '0.0.2'
  s.date = '2017-08-14'
  s.summary = 'Bloc Course API Client'
  s.description = 'An API client for Bloc courses.'
  s.authors = ['RJ Morawski']
  s.email = 'rjmorawski@gmail.com'
  s.files = ['lib/bcc.rb']
  s.require_paths = ["lib"]
  s.homepage = 'http://rubygems.org/gems/bcc'
  s.license = 'MIT'
  s.add_runtime_dependency 'httparty', '~> 0.15'
  # s.add_runtime_dependency 'json', '~> 0.15'
end
