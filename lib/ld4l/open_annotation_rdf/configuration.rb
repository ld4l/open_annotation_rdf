module LD4L
  module OpenAnnotationRDF
    class Configuration

      attr_reader :base_uri
      attr_reader :localname_minter

      def self.default_base_uri
        @default_base_uri = "http://localhost/".freeze
      end
      private_class_method :default_base_uri

      def self.default_localname_minter
        # by setting to nil, it will use the default minter in the minter gem
        @default_localname_minter = nil
      end
      private_class_method :default_localname_minter

      def initialize
        @base_uri         = self.class.send(:default_base_uri)
        @localname_minter = self.class.send(:default_localname_minter)
      end

      def base_uri=(new_base_uri)
        @base_uri = new_base_uri
      end

      def reset_base_uri
        @base_uri = self.class.send(:default_base_uri)
      end

      def localname_minter=(new_minter)
        @localname_minter = new_minter
      end

      def reset_localname_minter
        @localname_minter = self.class.send(:default_localname_minter)
      end
    end
  end
end
