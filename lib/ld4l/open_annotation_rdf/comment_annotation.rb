module LD4L
  module OpenAnnotationRDF
    class CommentAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="cm"

      def initialize(*args)
        super(*args)
        m = get_values(:motivatedBy)
        set_value(:motivatedBy, RDFVocabularies::OA.commenting) unless m.kind_of?(Array) && m.size > 0
      end
    end
  end
end

