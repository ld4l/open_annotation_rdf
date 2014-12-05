module LD4L
  module OpenAnnotationRDF
    class Configuration

      attr_reader :base_uri
      attr_reader :localname_minter
      attr_reader :unique_tags

      def self.default_base_uri
        @default_base_uri = "http://localhost/".freeze
      end
      private_class_method :default_base_uri

      def self.default_localname_minter
        # by setting to nil, it will use the default minter in the minter gem
        @default_localname_minter = nil
      end
      private_class_method :default_localname_minter

      def self.default_unique_tags
        @default_unique_tags = true
      end
      private_class_method :default_unique_tags

      def initialize
        @base_uri         = self.class.send(:default_base_uri)
        @localname_minter = self.class.send(:default_localname_minter)
        @unique_tags      = self.class.send(:default_unique_tags)
      end

      ##
      # Set the base_uri to be used when generating rdf_subjects for new objects.
      # @example  rdf_subject = base_uri + local_name
      #
      # @param [String] new value for the base_uri
      #
      def base_uri=(new_base_uri)
        @base_uri = new_base_uri
      end

      ##
      # Set the base_uri to be used when generating rdf_subjects for new objects back to the default configuration.
      # @example  rdf_subject = base_uri + local_name
      #
      def reset_base_uri
        @base_uri = self.class.send(:default_base_uri)
      end

      ##
      # Set the minter to be used to generate the local name portion of the rdf_subjects for new objects.
      # Example:  rdf_subject = base_uri + local_name
      #
      # @param [Proc] block/proc code to use as a minter of local names for new rdf_subjects
      #
      def localname_minter=(new_minter)
        @localname_minter = new_minter
      end

      ##
      # Set the minter to be used to generate the local name portion of the rdf_subjects for new objects to the
      # default minter.
      # Example:  rdf_subject = base_uri + local_name
      #
      def reset_localname_minter
        @localname_minter = self.class.send(:default_localname_minter)
      end

      ##
      # Set whether the GEM should enforce uniqueness of user generated tags when using
      # the TagAnnotation::setTag method.
      #
      # @param [Boolean] new value for the base_uri
      #   true - enforce uniqueness (default)
      #     - annotations share TagBodys
      #     - setTag method looks for an existing TagBody with the tag value and reuses the existing TagBody
      #     - setTag to change a tag's value will create/reuse a different TagBody for the new tag value
      #   false - do not enforce uniqueness
      #     - annotation owns its TagBody
      #     - setTag first time call creates a TagBody with the tag value
      #     - setTag to change the tag's value will modify the tag value in this annotation's TagBody
      def unique_tags=(new_unique_indicator)
        @unique_tags = new_unique_indicator
      end

      ##
      # Set whether the GEM should enforce uniqueness of user generated tags, when using
      # the TagAnnotation::setTag method, to the default configuration (true).
      #
      # @see unique_tags=
      def reset_unique_tags
        @unique_tags = self.class.send(:default_unique_tags)
      end
    end
  end
end
