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

1. LD4L::OpenAnnotationRDF::Annotation - Implements an open annotation.
  a. Target and Body metadata
1. LD4L::OpenAnnotationRDF::CommentAnnotation - Extends Annotation to implement a comment annotation of free-form text.
1. LD4L::OpenAnnotationRDF::CommentBody - Extends Annotation to implement the body of a comment annotation holding the free-form text.
1. LD4L::OpenAnnotationRDF::TagAnnotation - Extends Annotation to implement a tag annotation of user specified short phrase tag.
1. LD4L::OpenAnnotationRDF::SemanticTagAnnotation - Extends Annotation to implement a semantic tag annotation with values limited to a controlled vocabulary.

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
