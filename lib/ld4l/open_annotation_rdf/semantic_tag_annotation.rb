module LD4L
  module OpenAnnotationRDF
    class SemanticTagAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="stg"

      configure :type => RDFVocabularies::OA.SemanticTag, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default

      # def initialize
      #   self.motivated_by = RDFVocabularies::OA.tagging  # TODO How to set a default value for motivated_by?
      # end
    end
end
end


