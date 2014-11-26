require 'ld4l/open_annotation_rdf/vocab/oa'
require 'ld4l/open_annotation_rdf/vocab/cnt'
require 'rdf'

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
      # Search the configured repository for a TagBody triple that has the tag value for the tag property.
      #
      # @param [String] tag value
      #
      # @return instance of TagBody if found; otherwise, nil
      #
      # @todo Need to query for a TagBody resource that already has the tag value.
      # @todo Stubbed to always return nil
      def self::fetch_by_tag_value( tag_value )
        # TODO: Need to query for a TagBody resource that already has the tag value.
        #       * if found - return resumed instance of TagBody
        #       * if not found - return nil

        # TODO:  STUBBED
        nil
      end

      def initialize(*args)
        super(*args)

        t = get_values(:type)
        t << RDFVocabularies::CNT.AsText
        set_value(:type,t)
      end
    end
  end
end
