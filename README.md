#LD4L::OpenAnnotationRDF

LD4L Open Annotation RDF provides tools for modeling annotations based on the Open Annotation ontology and persisting to a triplestore.

## Installation

Add this line to your application's Gemfile:

    gem 'ld4l-open_annotation_rdf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ld4l-open_annotation_rdf

## Usage

**Caveat:** This gem is part of the LD4L Project and is being used in that context.  There is no guarantee that the 
code will work in a usable way outside of its use in LD4L Use Cases.

### Models

The LD4L::OpenAnnotationRDF gem provides model definitions using the 
[ActiveTriples](https://github.com/no-reply/ActiveTriples) framework extension of 
[ruby-rdf/rdf](https://github.com/ruby-rdf/rdf).  The following models are provided:

1. LD4L::OpenAnnotationRDF::Target - Implements an open annotation target.
  a. Basic metadata about the target is maintained as defined in the Open Annotation ontology.
2. LD4L::OpenAnnotationRDF::Body - Models each item in a virtual collection.
  a. Each item is an ORE Proxy defined in the [ORE ontology](http://www.openarchives.org/ore/1.0/vocabulary#otherRelationships).

### Ontologies

The listed ontologies are used to represent the primary metadata about the annotations.
Other ontologies may also be used that aren't listed.
 
* [OA](http://www.openannotation.org/spec/core/)
* [RDF](http://www.w3.org/TR/rdf-syntax-grammar/)
* [Dublin Core (DC)](http://dublincore.org/documents/dces/)
* [Dublin Core Terms (DCTERMS)](http://dublincore.org/documents/dcmi-terms/)



## Contributing

1. Fork it ( https://github.com/[my-github-username]/ld4l-open_annotation_rdf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
