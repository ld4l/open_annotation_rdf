module LD4L
  module OpenAnnotationRDF
    class SemanticTagBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="stb"

      # USAGE: When creating a semantic tag body, use the URI of the controlled vocabulary term as the RDF Subject URI
      #        for an instance of this class.

      configure :type => RDFVocabularies::OA.SemanticTag,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default
    end
  end
end
