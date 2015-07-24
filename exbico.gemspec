$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'exbico/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'exbico'
  s.version     = Exbico::VERSION
  s.authors     = ['Alexander Krutov']
  s.email       = ['goozler@mail.ru']
  s.homepage    = 'https://github.com/Goozler/exbico'
  s.summary     = 'API class for http://exbico.ru/'
  s.description = 'Get credit rating from bureau'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'httparty'
  s.add_dependency 'nokogiri'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
end
