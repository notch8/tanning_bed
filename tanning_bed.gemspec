# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tanning_bed}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Kaufman"]
  s.date = %q{2010-06-15}
  s.description = %q{Tanning Bed is Solr for models.
Tanning Bed provides a Ruby interface for the Solr (http://lucene.apache.org/solr/) search engine to use in you're models not matter whether they are Datamapper, Active Record, Couchrest or just general Ruby classes.}
  s.email = %q{rob@notch8.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc", "README.txt", "lib/tasks/solr.rake", "lib/tasks/tanning_bed.rake", "version.txt"]
  s.files = [".gitignore", "History.txt", "Manifest.txt", "README.rdoc", "README.txt", "Rakefile", "lib/tanning_bed.rb", "lib/tasks/solr.rake", "lib/tasks/solr.rb", "lib/tasks/tanning_bed.rake", "spec/fixtures/burnt_model.rb", "spec/fixtures/tanning_model.rb", "spec/spec_helper.rb", "spec/tanning_bed_spec.rb", "tanning_bed.gemspec", "version.txt"]
  s.homepage = %q{http://notch8.com}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tanning_bed}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Tanning Bed is Solr for models}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<solr-ruby>, [">= 0.0.8"])
      s.add_development_dependency(%q<tanning_bed_solr>, [">= 0.0.1"])
      s.add_development_dependency(%q<bones>, [">= 3.4.0"])
    else
      s.add_dependency(%q<solr-ruby>, [">= 0.0.8"])
      s.add_dependency(%q<tanning_bed_solr>, [">= 0.0.1"])
      s.add_dependency(%q<bones>, [">= 3.4.0"])
    end
  else
    s.add_dependency(%q<solr-ruby>, [">= 0.0.8"])
    s.add_dependency(%q<tanning_bed_solr>, [">= 0.0.1"])
    s.add_dependency(%q<bones>, [">= 3.4.0"])
  end
end
