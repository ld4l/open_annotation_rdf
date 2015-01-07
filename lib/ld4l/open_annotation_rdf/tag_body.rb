module LD4L
  module OpenAnnotationRDF
    class TagBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="tb"

      configure :type => RDFVocabularies::OA.Tag,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :tag,     :predicate => RDFVocabularies::CNT.chars  # :type => XSD.string

      ##
      # Get a list of annotations using the tag value.
      #
      # @param [String] tag value
      #
      # @return array of annotation URIs
      #
      # NOTE: This method returns only persisted annotations.
      def self::annotations_using( tag_value )
        raise ArgumentError, 'Argument must be a string with at least one character'  unless
            tag_value.kind_of?(String) && tag_value.size > 0

        tb = self::fetch_by_tag_value( tag_value )
        return []  unless tb
        tag_uri = tb.rdf_subject

        # find usage by Annotations
        graph = ActiveTriples::Repositories.repositories[repository]
        query = RDF::Query.new({
                                   :annotation => {
                                       RDF.type =>  RDFVocabularies::OA.Annotation,
                                       RDFVocabularies::OA.hasBody => tag_uri,
                                   }
                               })
        results = query.execute(graph)

        # process results
        annotations = []
        results.each { |r| annotations << r.to_hash[:annotation] }
        annotations
      end


      ##
      # Search the configured repository for a TagBody triple that has the tag value for the tag property.
      #
      # @param [String] tag value
      #
      # @return instance of TagBody if found; otherwise, nil
      def self::fetch_by_tag_value( tag_value )
        raise ArgumentError, 'Argument must be a string with at least one character'  unless
            tag_value.kind_of?(String) && tag_value.size > 0

        graph = ActiveTriples::Repositories.repositories[repository]
        query = RDF::Query.new({
          :tagbody => {
            RDF.type =>  RDFVocabularies::OA.Tag,
            RDFVocabularies::CNT.chars => tag_value,
          }
        })

        tagbody = nil
        results = query.execute(graph)
        unless( results.empty? )
          tagbody_uri = results[0].to_hash[:tagbody]
          tagbody = LD4L::OpenAnnotationRDF::TagBody.new(tagbody_uri)
        end
        tagbody
      end

      def initialize(*args)
        super(*args)

        t = get_values(:type)
        t << RDFVocabularies::CNT.ContentAsText
        set_value(:type,t)
      end
    end
  end
end
