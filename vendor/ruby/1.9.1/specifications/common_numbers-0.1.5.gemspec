# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "common_numbers"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mariusz Nosinski"]
  s.date = "2011-04-18"
  s.description = "Common Numbers validates popular numbers like polish PESEL, NIP, REGON, or global ISBN, EAN, etc."
  s.email = ["marioosh@5dots.pl"]
  s.homepage = "http://github.com/marioosh/common_numbers"
  s.require_paths = ["lib"]
  s.rubyforge_project = "common_numbers"
  s.rubygems_version = "1.8.24"
  s.summary = "Basic library to validate numbers like PESEL, NIP, etc"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
