require 'ld4l/open_annotation_rdf/vocab/oa'
require 'ld4l/foaf_rdf'
require 'rdf'

module LD4L
  module OpenAnnotationRDF
    class Annotation < ActiveTriples::Resource

      @id_prefix="oa"

      configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default

      property :hasTarget,   :predicate => RDFVocabularies::OA.hasTarget    # :type => URI
      property :hasBody,     :predicate => RDFVocabularies::OA.hasBody
      property :annotatedBy, :predicate => RDFVocabularies::OA.annotatedBy, :class_name => LD4L::FoafRDF::Person
      property :annotatedAt, :predicate => RDFVocabularies::OA.annotatedAt  # :type => xsd:dateTime    # the time Annotation was created
      property :motivatedBy, :predicate => RDFVocabularies::OA.motivatedBy  # comes from RDFVocabularies::OA ontology
    end
  end
end

