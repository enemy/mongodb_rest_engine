# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongodb_rest_engine/version"

Gem::Specification.new do |s|
  s.name        = "mongodb_rest_engine"
  s.version     = MongodbRestEngine::VERSION.dup
  s.authors     = ["Olli Jokinen"]
  s.email       = ["olli.jokinen@enemy.fi"]
  s.homepage    = "https://github.com/enemy/mongodb_rest_engine"
  s.summary     = %q{MongoDB REST engine for Ruby on Rails applications}
  s.description = %q{MongoDB REST engine for Ruby on Rails applications}

  s.rubyforge_project = "mongodb_rest_engine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('mongo')
  s.add_dependency('bson_ext')
end
