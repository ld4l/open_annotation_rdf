module LD4L
  module OpenAnnotationRDF
    class TagAnnotation < LD4L::OpenAnnotationRDF::Annotation

      @localname_prefix="ta"

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
        raise ArgumentError, 'Argument must be a string with at least one character'  unless tag.kind_of?(String) && tag.size > 0

        # return existing body if tag value is unchanged
        old_tag = @body ? @body.tag : nil
        return @body if old_tag && old_tag.include?(tag)

        if LD4L::OpenAnnotationRDF.configuration.unique_tags
          # when unique_tags = true, try to find an existing TagBody with the tag value before creating a new TagBody
          # TODO Determine behavior of setTag when unique_tags=true
          #   Behaviour Options:
          #     * Look for an existing TagBody with this value.
          #     **  If none found, create a new TagBody.
          #     **  If one found, set @body to this TagBody
          #     **  If multiple found, use the first one found
          #           ### the same one may not be the first one found each time the query executes
          @body = LD4L::OpenAnnotationRDF.configuration.unique_tags ? LD4L::OpenAnnotationRDF::TagBody.fetch_by_tag_value(tag) : nil
          if @body == nil
            @body = LD4L::OpenAnnotationRDF::TagBody.new(
                ActiveTriples::LocalName::Minter.generate_local_name(
                    LD4L::OpenAnnotationRDF::TagBody, 10, @localname_prefix,
                    LD4L::OpenAnnotationRDF.configuration.localname_minter ))
            @body.tag = tag
          end
        else
          # when unique_tags = false, ???  (see TODO)
          # TODO Determine behavior of setTag when unique_tags=false
          #   Behaviour Options:
          #     * If this TagAnnotation does not have a TagBody (@body) set, then create a new TagBody.
          #     * If this TagBody is used only by this TagAnnotation, then change the value in the TagBody.
          #     * If this TagBody is used by multiple TagAnnotations,
          #     **  EITHER change the value in the TagBody which changes it for all the TagAnnotations.
          #           ### Likely an undesirable side effect having the value change for all TagAnnotations
          #     **  OR create a new TagBody and update @body to that TagBody
          #   OR
          #     * [CURRENT] Always create a new TagBody each time setTag is called and update @body
          #         ### This last options has the potential for orphaned TagBodys that no TagAnnotation references.
          # TODO Rethink the current behavior which is always to create a new TagBody potentially leaving around orphans.
          @body = LD4L::OpenAnnotationRDF::TagBody.new(
              ActiveTriples::LocalName::Minter.generate_local_name(
                  LD4L::OpenAnnotationRDF::TagBody, 10, @localname_prefix,
                  LD4L::OpenAnnotationRDF.configuration.localname_minter ))
          @body.tag = tag
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

      def destroy
        # TODO Determine behavior of destroy
        #   Behaviour Options
        #     * Always destroy TagAnnotation
        #     * Handling of TagBody
        #     **  If TagBody is used only by this TagAnnotation, destroy it.
        #     **  Otherwise, do not destroy it.
        # TODO Write tests for this behaviour.
        # TODO Write code here to enforce.
        super
      end
    end
  end
end

