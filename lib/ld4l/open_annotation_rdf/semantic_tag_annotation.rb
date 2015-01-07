module LD4L
  module OpenAnnotationRDF
    class SemanticTagAnnotation < LD4L::OpenAnnotationRDF::Annotation

      @localname_prefix = "sta"

      # USAGE: Use setTerm to set the hasBody property to be the URI of the controlled vocabulary term that
      #        is the annotation.

      # TODO: Should a semantic tag be destroyed when the last annotation referencing the term is destroyed?

      ##
      # Set the hasBody property to the URI of the controlled vocabulary term that is the annotation and
      # create the semantic tag body instance identifying the term as a semantic tag annotation.
      #
      # @param [String]
      #
      # @return instance of SemanticTagBody
      def setTerm(cv_uri)
        cv_uri = RDF::URI(cv_uri) unless cv_uri.kind_of?(RDF::URI)
        @body = LD4L::OpenAnnotationRDF::SemanticTagBody.new(cv_uri)
        set_value(:hasBody, @body)
        @body
      end

      ##
      # Special processing for new and resumed SemanticTagAnnotations
      #
      def initialize(*args)
        super(*args)

        # set motivatedBy
        m = get_values(:motivatedBy)
        set_value(:motivatedBy, RDFVocabularies::OA.tagging) unless m.kind_of?(Array) && m.size > 0

        # resume SemanticTagBody if it exists
        cv_uri = get_values(:hasBody).first
        if( cv_uri )
          cv_uri = cv_uri.rdf_subject  if cv_uri.kind_of?(ActiveTriples::Resource)
          @body  = LD4L::OpenAnnotationRDF::SemanticTagBody.new(cv_uri)
        end
      end

      def destroy
        # TODO Determine behavior of destroy
        #   Behaviour Options
        #     * Always destroy SemanticTagAnnotation
        #     * Handling of SemanticTagBody
        #     **  If SemanticTagBody is used only by this SemanticTagAnnotation, destroy it.
        #     **  Otherwise, do not destroy it.
        # TODO Write tests for this behaviour.
        # TODO Write code here to enforce.
        super
      end
    end
  end
end


