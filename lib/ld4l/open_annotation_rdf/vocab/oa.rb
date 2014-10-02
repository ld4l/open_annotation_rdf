module RDFVocabularies
  class OA < RDF::Vocabulary("http://www.w3.org/ns/oa#")

    # Class definitions
    term :Annotation
    term :Motivation
    term :Tag
    term :SemanticTag

    # Property definitions
    property :hasBody
    property :hasTarget
    property :annotatedBy  # relationship identifying the agent responsible for creating the Annotation
    property :annotatedAt  # the time at which the Annotation was created
    property :motivatedBy  # relationship for Motivation

    # Instances of :Motivation class used as the object of predicate :motivatedBy
    property :commenting   # an instance for OA:Motivation  (ex. <anAnnotationURI> <ao:motivatedBy> <oa:commenting>)
    property :tagging      # an instance for OA:Motivation  (ex. <anAnnotationURI> <ao:motivatedBy> <oa:tagging>)
    property :describing   # an instance for OA:Motivation  (ex. <anAnnotationURI> <ao:motivatedBy> <oa:describing>)
    property :classifying   # an instance for OA:Motivation  (ex. <anAnnotationURI> <ao:motivatedBy> <oa:classifying>)
  end
end
