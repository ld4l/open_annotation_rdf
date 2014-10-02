module LD4L
  module OpenAnnotationRDF
    class TagAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="tg"

      configure :type => RDFVocabularies::OA.Tag, :base_uri => Rails.configuration.urigenerator.base_uri, :repository => :default

      # def initialize
      #   self.motivated_by = RDFVocabularies::OA.tagging  # TODO How to set a default value for motivated_by?
      # end
    end
  end
end

