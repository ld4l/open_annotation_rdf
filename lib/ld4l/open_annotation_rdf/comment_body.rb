require 'ld4l/open_annotation_rdf/vocab/cnt'
require 'rdf'

module LD4L
  module OpenAnnotationRDF
    class CommentBody < ActiveTriples::Resource

      @id_prefix="cb"

      configure :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default

      property :type,    :predicate => RDF::type                   # :type => URI         # Set up here because need to set two types.
      property :content, :predicate => RDFVocabularies::CNT.chars  # :type => XSD.string
      property :format,  :predicate => RDF::DC.format              # :type => XSD.string
    end
  end
end
