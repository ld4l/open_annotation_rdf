require 'ld4l/open_annotation_rdf/vocab/oa'
require 'ld4l/foaf_rdf'
require 'rdf'

module LD4L
  module OpenAnnotationRDF
    class Annotation < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="oa"

      @body = nil

      configure :type => RDFVocabularies::OA.Annotation,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :hasTarget,   :predicate => RDFVocabularies::OA.hasTarget    # :type => URI
      property :hasBody,     :predicate => RDFVocabularies::OA.hasBody
      property :annotatedBy, :predicate => RDFVocabularies::OA.annotatedBy, :class_name => LD4L::FoafRDF::Person
      property :annotatedAt, :predicate => RDFVocabularies::OA.annotatedAt  # :type => xsd:dateTime    # the time Annotation was created
      property :motivatedBy, :predicate => RDFVocabularies::OA.motivatedBy  # comes from RDFVocabularies::OA ontology

      ##
      # Get the <tt>ActiveTriples::Resource</tt> instance holding the body of this annotation.
      #
      # @param [String] tag value
      #
      # @return instance of an annotation body if one is set; otherwise, nil
      def getBody
        @body
      end

      ##
      # Set annotatedAt property to now.
      #
      # @return the value of annotatedAt property
      def setAnnotatedAtNow
        set_value(:annotatedAt, Time.now.utc.iso8601(0))
      end

      ##
      # Save all annotation and annotation body triples to the triple store.
      #
      # @return true if annotation successfully persisted; otherwise, false
      #
      # @todo What to return if annotation persists fine, but body fails to persist?
      def persist!
        persisted = super                                               # persist annotation
        body_persisted = persisted && @body ? @body.persist! : false    # persist body
        persisted
      end
    end
  end
end

