module LD4L
  module OpenAnnotationRDF
    class TagAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="tg"

      configure :type => RDFVocabularies::OA.Tag, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default

      def initialize(*args)
        super(*args)
        m = get_values(:motivatedBy)
        set_value(:motivatedBy, RDFVocabularies::OA.tagging) unless m.kind_of?(Array) && m.size > 0
      end
    end
  end
end

