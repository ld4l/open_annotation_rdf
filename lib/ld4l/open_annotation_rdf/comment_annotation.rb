module LD4L
  module OpenAnnotationRDF
    class CommentAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="cm"

      # def initialize
      #   self.motivated_by = RDFVocabularies::OA.commenting  # TODO How to set a default value for motivated_by?
      # end
    end
  end
end

