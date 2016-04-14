0.1.0
-----
* Updated to work with ActiveTriples 0.5, 0.6, and 0.8.2

0.0.12 (pre-release)
------
* add convenience method SemanticTagAnnotation.getTerm

0.0.11 (pre-release)
------
* add convenience methods
  * add Annotations.find_by_target
  * add CommentAnnotation.getComment
  * add TagAnnotation.getTag

0.0.10 (pre-release)
------
* Improve functioning of Annotation#resume
  * add SemanticTagBody class to hasBody property in SemanticTag
  * remove class validation of motivatedBy in the resume method because it can have multiple classes; validation of value is sufficient
* Add tests for body as blank node
  * add tests for Annotation#resume where body as blank node was created using the gem models
  * add tests for Annotation#resume where body as blank node was loaded from an RDF::Graph

0.0.9 (pre-release)
-----
* FIX: cast should set be to false not true

0.0.8 (pre-release)
-----
* Add casting restrictions
* Let Annotation.resume receive same parameters as .new
  * Annotation.resume now accepts the following values for its parameter.
    * RDF::URI - e.g. RDF::URI('http://example.org/t123') -- this is the only value accepted prior to this change
    * string URI - e.g. 'http://example.org/t123'
    * localname - e.g. 't123' -- This will be expanded by appending 't123' to the end of the configured base_uri

0.0.6 (pre-release)
-----
* Reduce required ruby to 1.9.3

0.0.4 (pre-release)
-----
* Initial release of gem
* Supports following annotation types:
  * Comment Annotation - free form text
  * Tag Annotation - one word or short phrase tag written by the user
  * Semantic Tag Annotation - term from a controlled vocabulary
* See README for more information and usage examples.
