# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ld4l/open_annotation_rdf/version'

Gem::Specification.new do |spec|
  spec.name          = "ld4l-open_annotation_rdf"
  spec.version       = LD4L::OpenAnnotationRDF::VERSION
  spec.authors       = ["E. Lynette Rayle"]
  spec.email         = ["elr37@cornell.edu"]
  spec.platform      = Gem::Platform::RUBY
  spec.summary       = %q{OpenAnnotation RDF models.}
  spec.description   = %q{LD4L Open Annotation RDF provides tools for modeling a annotations based on the Open Annotation ontology and persisting to a triplestore.}
  spec.homepage      = "https://github.com/ld4l/open_annotation_rdf"
  spec.license       = "APACHE2"
  spec.required_ruby_version     = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  # spec.test_files    = `git ls-files -- {spec}/*`.split("\n")               # FROM ActiveTriples gemspec file
  # spec.require_paths = ["lib"]                                              # NOT IN ActiveTriples gemspec file

#  spec.add_dependency('ffi', '~> 1.9.5')
  spec.add_dependency('rdf', '~> 1.1')
  spec.add_dependency('active-triples', '~> 0.2')

  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('webmock')

  spec.extra_rdoc_files = [
      "LICENSE.txt",
      "README.md"
  ]
end

