# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nested_exceptions/version"

Gem::Specification.new do |s|
  s.name        = "nested_exceptions"
  s.version     = NestedExceptions::VERSION
  s.authors     = ["Darrick Wiebe"]
  s.email       = ["dw@xnlogic.com"]
  s.homepage    = ""
  s.summary     = %q{Support nested exceptions in all rubies}
  s.description = %q{Based on ideas in http://exceptionalruby.com/ and the nestegg gem which does not support JRuby.}

  s.rubyforge_project = "nested_exceptions"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "autotest"
end
