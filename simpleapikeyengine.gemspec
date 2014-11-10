$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simpleapikeyengine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simpleapikeyengine"
  s.version     = SimpleApiKeyEngine::VERSION
  s.authors     = ['Yuichi Takeuchi']
  s.email       = ['uzuki05@takeyu-web.com']
  s.homepage    = 'https://github.com/takeyuweb/simpleapikeyengine'
  s.summary     = 'Simple API Key Engine.'
  s.description = '(Description for simpleapikeyengine)'
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec'
end
