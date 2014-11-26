require 'active_triples/local_name'

module LD4L
  module OpenAnnotationRDF
    class TagAnnotation < LD4L::OpenAnnotationRDF::Annotation
      @id_prefix="tg"

      property :hasBody,  :predicate => RDFVocabularies::OA.hasBody,   :class_name => LD4L::OpenAnnotationRDF::TagBody

      # TODO: Should a tag be destroyed when the last annotation referencing the tag is destroyed?

      ##
      # Set the hasBody property to the URI of the one and only TagBody holding the tag value. Create a new TagBody
      # if one doesn't exist with this value.
      #
      # @param [String] tag value
      #
      # @return instance of TagBody
      def setTag(tag)
        @body = LD4L::OpenAnnotationRDF::TagBody.fetch_by_tag_value(tag)
        if @body == nil
          @body = LD4L::OpenAnnotationRDF::TagBody.new(
              ActiveTriples::LocalName::Minter.generate_local_name(
                  LD4L::OpenAnnotationRDF::TagBody, 10, @id_prefix,
                  LD4L::OpenAnnotationRDF.configuration.localname_minter ))
          @body.tag = 'foo'
        end
        set_value(:hasBody, @body)
        @body
      end

      ##
      # Special processing for new and resumed TagAnnotations
      #
      def initialize(*args)
        super(*args)

        # set motivatedBy
        m = get_values(:motivatedBy)
        set_value(:motivatedBy, RDFVocabularies::OA.tagging) unless m.kind_of?(Array) && m.size > 0

        # resume TagBody if it exists
        tag_uri = get_values(:hasBody).first
        if( tag_uri )
          tag_uri = tag_uri.rdf_subject  if tag_uri.kind_of?(ActiveTriples::Resource)
          @body  = LD4L::OpenAnnotationRDF::TagBody.new(tag_uri)
        end
      end
    end
  end
end

