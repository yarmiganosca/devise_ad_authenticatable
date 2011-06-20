# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_ad_authenticatable/version"

Gem::Specification.new do |s|
  s.name        = "devise_ad_authenticatable"
  s.version     = DeviseAdAuthenticatable::VERSION
  s.authors     = ["Chris Hoffman"]
  s.email       = ["choffman@beechstcap.com"]
  s.homepage    = ""
  s.summary     = %q{Version of devise_ldap_authenticatable for Active Directory}
  s.description = %q{Version of devise_ldap_authenticatable for Active Directory}

  s.rubyforge_project = "devise_ad_authenticatable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
