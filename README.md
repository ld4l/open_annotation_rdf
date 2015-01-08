#LD4L::OpenAnnotationRDF

[![Build Status](https://travis-ci.org/ld4l/open_annotation_rdf.png?branch=master)](https://travis-ci.org/ld4l/open_annotation_rdf) 
[![Test Coverage](https://img.shields.io/coveralls/ld4l/open_annotation_rdf.svg?branch=master)](https://coveralls.io/r/ld4l/open_annotation_rdf) 
[![Gem Version](https://badge.fury.io/rb/ld4l-open_annotation_rdf.svg)](http://badge.fury.io/rb/ld4l-open_annotation_rdf)
[![Dependency Status](https://www.versioneye.com/ruby/ld4l-open_annotation_rdf/0.0.4/badge.svg)](https://www.versioneye.com/ruby/ld4l-open_annotation_rdf/0.0.4)


LD4L Open Annotation RDF provides tools for modeling annotations based on the Open Annotation ontology and persisting to a triplestore.


## Installation

Add this line to your application's Gemfile:

    gem 'ld4l-open_annotation_rdf'
    

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ld4l-open_annotation_rdf


## Usage

**Caveat:** This gem is part of the LD4L Project and is being used in that context.  There is no guarantee that the 
code will work in a usable way outside of its use in LD4L Use Cases.

### Examples

*Setup required for all examples.*
```
require 'ld4l/open_annotation_rdf'

# create an in-memory repository
ActiveTriples::Repositories.add_repository :default, RDF::Repository.new

p = LD4L::FoafRDF::Person.new('p4')
```

*Example creating a comment annotation.*
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

*Example triples created for a comment annotation.*
```
<http://localhost/c10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:53:49Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://localhost/9c8c8126-2d31-48be-81d8-3cd4748a3351>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .

<http://localhost/9c8c8126-2d31-48be-81d8-3cd4748a3351> a <http://www.w3.org/2011/content#ContentAsText>,
                                                          <http://purl.org/dc/dcmitype/Text>;
   <http://purl.org/dc/terms/format> "text/plain";
   <http://www.w3.org/2011/content#chars> "This book is a good resource on archery technique." .
```

*Example creating a tag annotation.*
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

*Example triples created for a tag annotation.*
```
<http://localhost/t10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:56:32Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://localhost/88db4b38-8b99-4939-b376-1392019aa30c>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> .

<http://localhost/88db4b38-8b99-4939-b376-1392019aa30c> a <http://www.w3.org/ns/oa#Tag>,
                                                          <http://www.w3.org/2011/content#ContentAsText>;
   <http://www.w3.org/2011/content#chars> "archery" .
```

*Example creating a semantic tag annotation.*
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

*Example triples created for a semantic tag annotation.*
```
<http://localhost/st10> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#annotatedAt> "2014-11-26T15:59:01Z";
   <http://www.w3.org/ns/oa#annotatedBy> <http://localhost/p4>;
   <http://www.w3.org/ns/oa#hasBody> <http://example.org/term/engineering>;
   <http://www.w3.org/ns/oa#hasTarget> <http://example.org/bibref/br3>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> .

<http://example.org/term/engineering> a <http://www.w3.org/ns/oa#SemanticTag> .
```


### Configurations

* base_uri - base URI used when new resources are created (default="http://localhost/")
* localname_minter - minter function to use for creating unique local names (default=nil which uses default minter in active_triples-local_name gem)
* unique_tags - if true, re-use existing TagBodies only creating a new TagBody if one doesn't exist with the tag value being set; otherwise, if false, create new TagBody when tag value is updated (default=true)

*Setup for all examples.*

* Restart your interactive session (e.g. irb, pry).
* Use the Setup for all examples in main Examples section above.

#### Example usage using **configured base_uri** and default localname_minter.
```
LD4L::OpenAnnotationRDF.reset
LD4L::OpenAnnotationRDF.configure do |config|
  config.base_uri = "http://example.org/"
end

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, {:prefix=>'ca'} ))

puts ca.dump :ttl

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, {:prefix=>'ca'},
              &LD4L::OpenAnnotationRDF.configuration.localname_minter ))

puts ca.dump :ttl
```
NOTE: If base_uri is not used, you need to restart your interactive environment (e.g. irb, pry).  Once the 
  CommentAnnotation class is instantiated the first time, the base_uri for the class is set.  If you ran
  through the main Examples, the base_uri was set to the default base_uri.


**Example triples created for a person with configured base_uri and default minter.**
```
<http://example.org/ca45c9c85b-25af-4c52-96a4-cf0d8b70a768> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .
```

#### Example usage using **configured base_uri** and **configured localname_minter**.
```
LD4L::OpenAnnotationRDF.configure do |config|
  config.base_uri = "http://example.org/"
  config.localname_minter = lambda { |prefix=""| prefix+'_configured_'+SecureRandom.uuid }
end

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, 'ca',
              &LD4L::OpenAnnotationRDF.configuration.localname_minter ))

puts ca.dump :ttl
```
NOTE: If base_uri is not used, you need to restart your interactive environment (e.g. irb, pry).  Once the 
  CommentAnnotation class is instantiated the first time, the base_uri for the class is set.  If you ran
  through the main Examples, the base_uri was set to the default base_uri.


**Example triples created for a person with configured base_uri and configured minter.**
```
<http://example.org/ca_configured_6498ba05-8b21-4e8c-b9d4-a6d5d2180966> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .
```

#### Example configuring unique_tags
```
# Any of these are valid and will change the configuration of unique_tags
LD4L::OpenAnnotationRDF.configuration.unique_tags = true
LD4L::OpenAnnotationRDF.configuration.unique_tags = false
LD4L::OpenAnnotationRDF.configuration.reset_unique_tags
```

### Models

The LD4L::OpenAnnotationRDF gem provides model definitions using the 
[ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) framework extension of 
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
* [FOAF](http://xmlns.com/foaf/spec/)
* [RDF](http://www.w3.org/TR/rdf-syntax-grammar/)
* [Dublin Core (DC)](http://dublincore.org/documents/dces/)
* [Dublin Core Terms (DCTERMS)](http://dublincore.org/documents/dcmi-terms/)



## Contributing

1. Fork it ( https://github.com/[my-github-username]/ld4l-open_annotation_rdf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
