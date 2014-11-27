module LD4L
  module OpenAnnotationRDF
    class CommentBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="cb"

      configure :type => RDFVocabularies::CNT.AsText,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :content, :predicate => RDFVocabularies::CNT.chars  # :type => XSD.string
      property :format,  :predicate => RDF::DC.format              # :type => XSD.string

      def initialize(*args)
        super(*args)

        t = get_values(:type)
        t << RDFVocabularies::DCTYPES.Text
        set_value(:type,t)
      end
    end
  end
end
