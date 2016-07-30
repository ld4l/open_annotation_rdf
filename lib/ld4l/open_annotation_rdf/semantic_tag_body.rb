module LD4L
  module OpenAnnotationRDF
    class SemanticTagBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="stb"

      # USAGE: When creating a semantic tag body, use the URI of the controlled vocabulary term as the RDF Subject URI
      #        for an instance of this class.

      configure :type => RDF::Vocab::OA.SemanticTag,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      ##
      # Get a list of annotations using a term.
      #
      # @param [String] controlled vocabulary uri for the term
      #
      # @return array of annotation URIs
      #
      # NOTE: This method returns only persisted annotations.
      def self::annotations_using( term_uri )
        raise ArgumentError, 'Argument must be a uri string or an instance of RDF::URI'  unless
            term_uri.kind_of?(String) && term_uri.size > 0 || term_uri.kind_of?(RDF::URI)

        term_uri = RDF::URI(term_uri) unless term_uri.kind_of?(RDF::URI)

        # find usage by Annotations
        repo = ActiveTriples::Repositories.repositories[repository]
        query = RDF::Query.new({
                                   :annotation => {
                                       RDF.type =>  RDF::Vocab::OA.Annotation,
                                       RDF::Vocab::OA.hasBody => term_uri,
                                   }
                               })
        annotations = []
        results = query.execute(repo)
        results.each { |r| annotations << r.to_hash[:annotation] }
        annotations
      end


      ##
      # Destroy the SemanticTagBody only if the term is not used by another SemanticAnnotation
      #
      # @param [String] controlled vocabulary uri for the term
      #
      # @return true if destroyed; otherwise, false if used by other annotations
      #
      # NOTE: Use this method after changing the term AND persisting the annotation on which the term was changed.
      def self::destroy_if_unused( term_uri )
        raise ArgumentError, 'Argument must be a uri string or an instance of RDF::URI'  unless
            term_uri.kind_of?(String) && term_uri.size > 0 || term_uri.kind_of?(RDF::URI)

        term_uri = RDF::URI(term_uri) unless term_uri.kind_of?(RDF::URI)

        # find usage by Annotations
        annotations = self::annotations_using( term_uri )
        destroyed = false
        if( annotations.empty? )
          stb = LD4L::OpenAnnotationRDF::SemanticTagBody.new(term_uri)
          destroyed = stb.destroy!
        end
        destroyed
      end

    end
  end
end
