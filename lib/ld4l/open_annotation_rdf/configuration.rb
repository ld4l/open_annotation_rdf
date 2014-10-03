module LD4L
  module OpenAnnotationRDF
    class Configuration

      attr_reader :base_uri
      attr_writer   :person_base_uri

      def initialize
        @person_base_uri = nil
        @base_uri = "http://localhost:3000/"
      end

      def person_base_uri
        @person_base_uri ||= @base_uri
      end

      def base_uri=(new_base_uri)
        @base_uri = new_base_uri
      end
    end
  end
end
