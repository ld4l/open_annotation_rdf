module LD4L
  module OpenAnnotationRDF
    class CommentBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="cb"

      configure :type => RDF::Vocab::CNT.ContentAsText,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :content, :predicate => RDF::Vocab::CNT.chars,  :cast => false  # :type => XSD.string
      property :format,  :predicate => RDF::Vocab::DC.format,              :cast => false  # :type => XSD.string

      def initialize(*args)
        super(*args)

        t = get_values(:type)
        t << RDF::Vocab::DCMIType.Text
        set_value(:type,t)
      end
    end
  end
end
