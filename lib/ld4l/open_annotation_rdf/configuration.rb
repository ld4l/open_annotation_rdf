module LD4L
  module OpenAnnotationRDF

    # Used by LD4L::OpenAnnotationRDF class to configure...
    # * base_uri
    # * local_minter
    # * unique_tags
    #
    # @example Configure all configurable properties
    #   LD4L::OpenAnnotationRDF.configure do |config|
    #     config.base_uri         = "http://www.example.org/annotations/"
    #     config.localname_minter = lambda { |prefix=""| prefix+SecureRandom.uuid }
    #     config.unique_tags      = true
    #   end
    #
    # @example Usage of base uri and local name
    #   # uri = base_uri + localname"
    #   annotation = LD4L::OpenAnnotationRDF::CommentAnnotation.new(
    #     ActiveTriples::LocalName::Minter.generate_local_name(
    #         LD4L::OpenAnnotationRDF::CommentBody, 10, 'a',
    #         LD4L::OpenAnnotationRDF.configuration.localname_minter ))
    #   annotation.rdf_subject
    #   # => "http://www.example.org/annotations/a9f85752c-9c2c-4a65-997a-68482895a656"
    #
    # @note Use LD4L::OpenAnnotationRDF.configure to call the methods in this class.  See 'Configure all configurable
    #   properties' example for most common approach to configuration.
    class Configuration

      ##
      # @overload base_uri
      #   Get the base_uri to be used when generating rdf_subjects for new objects.  See example configuration and usage in class documentation examples.
      #   @return the configured base_uri
      # @overload base_uri=(new_base_uri)
      #   Set the base_uri to be used when generating rdf_subjects for new objects.  See example configuration and usage in class documentation examples.
      #   @param [String] new value for the base_uri
      #   @note base_uri will only take effect when a model class is first created.  Once the model class is created, the base_uri is bound to the class.
      attr_reader :base_uri

      ##
      # @overload localname_minter
      #   Get the localname_minter to be used when generating rdf_subjects for new objects.  See example configuration and usage in class documentation examples.
      #   @return the configured localname_minter
      # @overload localname_minter=(new_localname_minter)
      #   Set the localname_minter to be used when generating rdf_subjects for new objects.  See example configuration and usage in class documentation examples.
      #   @param [String] new value for the localname_minter
      attr_reader :localname_minter

      ##
      # @overload unique_tags
      #   Get whether the GEM should enforce uniqueness of user generated tags when using
      #   the TagAnnotation::setTag method.  See example configuration and usage in class documentation examples.
      #   @return the configured unique_tags
      # @overload unique_tags=(new_unique_tags)
      #   Set whether the GEM should enforce uniqueness of user generated tags when using
      #   the TagAnnotation::setTag method.
      #   @param [Boolean] new value for the unique_tags
      #
      #     true - enforce uniqueness (default)
      #       - annotations share TagBodys
      #       - setTag method looks for an existing TagBody with the tag value and reuses the existing TagBody
      #       - setTag to change a tag's value will create/reuse a different TagBody for the new tag value
      #     false - do not enforce uniqueness
      #       - annotation owns its TagBody
      #       - setTag first time call creates a TagBody with the tag value
      #       - setTag to change the tag's value will modify the tag value in this annotation's TagBody
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

      def base_uri=(new_base_uri)
        @base_uri = new_base_uri
      end

      ##
      # Reset the base_uri to be used when generating rdf_subject for new objects back to the default configuration.
      #
      def reset_base_uri
        @base_uri = self.class.send(:default_base_uri)
      end

      def localname_minter=(new_minter)
        @localname_minter = new_minter
      end

      ##
      # Reset the minter to be used to generate the local name portion of the rdf_subject for new objects to the
      # default minter.
      #
      def reset_localname_minter
        @localname_minter = self.class.send(:default_localname_minter)
      end

      def unique_tags=(new_unique_indicator)
        @unique_tags = new_unique_indicator
      end

      ##
      # Reset whether the GEM should enforce uniqueness of user generated tags, when using
      # the TagAnnotation::setTag method, to the default configuration (true).
      #
      # @see unique_tags=
      def reset_unique_tags
        @unique_tags = self.class.send(:default_unique_tags)
      end
    end
  end
end
