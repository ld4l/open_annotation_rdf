module LD4L
  module OpenAnnotationRDF
    class SemanticTagAnnotation < LD4L::OpenAnnotationRDF::Annotation

      @localname_prefix = "sta"

      configure :type => RDFVocabularies::OA.Annotation,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :hasBody, :predicate => RDFVocabularies::OA.hasBody, :class_name => LD4L::OpenAnnotationRDF::SemanticTagBody


      # USAGE: Use setTerm to set the hasBody property to be the URI of the controlled vocabulary term that
      #        is the annotation.

      # TODO: Should a semantic tag be destroyed when the last annotation referencing the term is destroyed?
      # TODO: What if other triples have been attached beyond the type?

      ##
      # Get the term URI of the semantic tag body.
      #
      # @return the term URI
      def getTerm
        # return existing body if term is unchanged
        @body ? @body.rdf_subject : nil
      end

      ##
      # Set the hasBody property to the URI of the controlled vocabulary term that is the annotation and
      # create the semantic tag body instance identifying the term as a semantic tag annotation.
      #
      # @param [String] controlled vocabulary uri for the term
      #
      # @return instance of SemanticTagBody
      def setTerm(term_uri)
        raise ArgumentError, 'Argument must be a uri string or an instance of RDF::URI'  unless
            term_uri.kind_of?(String) && term_uri.size > 0 || term_uri.kind_of?(RDF::URI)

        # return existing body if term is unchanged
        old_term_uri = @body ? @body.rdf_subject.to_s : nil
        term_uri = RDF::URI(term_uri) unless term_uri.kind_of?(RDF::URI)
        return @body if old_term_uri && old_term_uri == term_uri.to_s

        @body = LD4L::OpenAnnotationRDF::SemanticTagBody.new(term_uri)
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
        term_uri = get_values(:hasBody).first
        if( term_uri )
          term_uri = term_uri.rdf_subject  if term_uri.kind_of?(ActiveTriples::Resource)
          @body  = LD4L::OpenAnnotationRDF::SemanticTagBody.new(term_uri)
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


