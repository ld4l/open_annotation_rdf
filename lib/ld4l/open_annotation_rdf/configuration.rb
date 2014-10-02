module LD4L
  module OpenAnnotationRDF
    class Configuration

      attr_reader :base_uri

      def initialize
        @base_uri = "http://localhost:3000/"
      end

      def base_uri=(new_base_uri)
        @base_uri = new_base_uri
      end
    end
  end
end
