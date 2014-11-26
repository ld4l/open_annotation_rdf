#LD4L::OpenAnnotationRDF

LD4L Open Annotation RDF provides tools for modeling annotations based on the Open Annotation ontology and persisting to a triplestore.

## Installation


Temporary get the gem from github until the gem is released publicly.

Add this line to your application's Gemfile:

<!--    gem 'ld4l-open_annotation_rdf' -->
    gem 'ld4l-open_annotation_rdf', '~> 0.0.3', :git => 'git@github.com:ld4l/open_annotation_rdf.git'
    

And then execute:

    $ bundle install

<!--
Or install it yourself as:

    $ gem install ld4l-open_annotation_rdf
-->

## Usage

**Caveat:** This gem is part of the LD4L Project and is being used in that context.  There is no guarantee that the 
code will work in a usable way outside of its use in LD4L Use Cases.

### Examples

Setup required for all examples.
```
require 'active_triples'
require 'ld4l/open_annotation_rdf'
require 'ld4l/foaf_rdf'

# create an in-memory repository
ActiveTriples::Repositories.add_repository :default, RDF::Repository.new

p = LD4L::FoafRDF::Person.new('p4')
```

Example creating a comment annotation.
```
ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new('c10')
ca.hasTarget = RDF::URI("http://example.org/bibref/br3")
cb = ca.setComment("This book is a good resource on archery technique.")
ca.annotatedBy = p
ca.setAnnotatedAtNow
ca.persist!

puts ca.dump :ttl
puts cb.dump :ttl
```

Example triples created for a comment annotation.
```
<http://localhost/c10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:53:49Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://localhost/9c8c8126-2d31-48be-81d8-3cd4748a3351>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .

<http://localhost/9c8c8126-2d31-48be-81d8-3cd4748a3351> a <http://www.w3.org/2011/content#AsText>,
                                                          <http://purl.org/dc/dcmitype/Text>;
   <http://purl.org/dc/terms/format> "text/plain";
   <http://www.w3.org/2011/content#chars> "This book is a good resource on archery technique." .
```

Example creating a tag annotation.
```
ta = LD4L::OpenAnnotationRDF::TagAnnotation.new('t10')
ta.hasTarget = RDF::URI("http://example.org/bibref/br3")
tb = ta.setTag("archery")
ta.annotatedBy = p
ta.setAnnotatedAtNow
ta.persist!

puts ta.dump :ttl
puts tb.dump :ttl
```

Example triples created for a tag annotation.
```
<http://localhost/t10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:56:32Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://localhost/88db4b38-8b99-4939-b376-1392019aa30c>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> .

<http://localhost/88db4b38-8b99-4939-b376-1392019aa30c> a <http://www.w3.org/ns/oa#Tag>,
                                                          <http://www.w3.org/2011/content#AsText>;
   <http://www.w3.org/2011/content#chars> "archery" .
```

Example creating a semantic tag annotation.
```
sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('st10')
sta.hasTarget = RDF::URI("http://example.org/bibref/br3")
stb = sta.setTerm(RDF::URI("http://example.org/term/engineering"))
sta.annotatedBy = p
sta.setAnnotatedAtNow
sta.persist!

puts sta.dump :ttl
puts stb.dump :ttl
```

Example triples created for a semantic tag annotation.
```
<http://localhost/st10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:59:01Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://example.org/term/engineering>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> .

<http://example.org/term/engineering> a <http://www.w3.org/ns/oa#SemanticTag> .
```


### Models

The LD4L::OpenAnnotationRDF gem provides model definitions using the 
[ActiveTriples](https://github.com/no-reply/ActiveTriples) framework extension of 
[ruby-rdf/rdf](https://github.com/ruby-rdf/rdf).  The following models are provided:

1. LD4L::OpenAnnotationRDF::Annotation - Implements an open annotation.
1. LD4L::OpenAnnotationRDF::CommentAnnotation - Extends Annotation to implement a comment annotation of free-form text.
1. LD4L::OpenAnnotationRDF::CommentBody - Implements a body holding free-form text.
1. LD4L::OpenAnnotationRDF::TagAnnotation - Extends Annotation to implement a tag annotation of user specified short phrase tag.
1. LD4L::OpenAnnotationRDF::TagBody - Implements a body holding the short phrase tag.
1. LD4L::OpenAnnotationRDF::SemanticTagAnnotation - Extends Annotation to implement a semantic tag annotation with values limited to a controlled vocabulary.
1. LD4L::OpenAnnotationRDF::SemanticTagBody - Implements a body with rdf_subject equal to the URI of the controlled vocabulary term
.

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
