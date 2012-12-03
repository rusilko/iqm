# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "common_numbers_rails"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mariusz Nosinski"]
  s.date = "2011-04-18"
  s.description = "Rails 3 validators for common numbers like PESEL, NIP, REGON"
  s.email = ["marioosh@5dots.pl"]
  s.homepage = "https://github.com/marioosh/common_numbers_rails"
  s.require_paths = ["lib"]
  s.rubyforge_project = "common_numbers_rails"
  s.rubygems_version = "1.8.24"
  s.summary = "Rails 3 validators for common numbers like PESEL, NIP, REGON"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<common_numbers>, [">= 0.1.5"])
      s.add_runtime_dependency(%q<activemodel>, [">= 3.0.0"])
    else
      s.add_dependency(%q<common_numbers>, [">= 0.1.5"])
      s.add_dependency(%q<activemodel>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<common_numbers>, [">= 0.1.5"])
    s.add_dependency(%q<activemodel>, [">= 3.0.0"])
  end
end
