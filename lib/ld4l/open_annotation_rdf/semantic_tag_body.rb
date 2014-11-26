require 'ld4l/open_annotation_rdf/vocab/oa'
require 'ld4l/open_annotation_rdf/vocab/cnt'
require 'rdf'

module LD4L
  module OpenAnnotationRDF
    class SemanticTagBody < ActiveTriples::Resource

      # USAGE: When creating a semantic tag body, use the URI of the controlled vocabulary term as the RDF Subject URI
      #        for an instance of this class.

      @id_prefix="stb"

      configure :type => RDFVocabularies::OA.SemanticTag,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default
    end
  end
end
