require 'active_triples'

module LD4L
  module OpenAnnotationRDF
    class ResourceExtension < ActiveTriples::Resource

      MAX_TRIES = 10000                           # TODO make max tries configurable
      PREFERRED_DIGITS = 99999                    # TODO make max digits configurable

      class << self
        attr_accessor :id_prefix
      end
      @id_prefix="s"

      def id_prefix
        if(defined? self.class.id_prefix)
          prefix = self.class.id_prefix.nil?  ? LD4L::OpenAnnotationRDF::ResourceExtension.id_prefix : self.class.id_prefix
        end
        prefix
      end

      def self.generate_id  # TODO if this is inefficient, could try multi-threading; Likely it won't be a problem and should find an ID within the first few attempts
        test_id = -1
        found = false
        digit_count = PREFERRED_DIGITS
        (1).upto(2) do                # try adding up to 2 more digits if not found in the preferred digit count
          (0).upto(MAX_TRIES) do
            test_id = Time.now.hash
            test_id *= -1 if test_id < 0
            test_id /= 10 while test_id > digit_count
            found = id_persisted?(test_id)
            break unless found
          end
          digit_count += 1 if found   # Allow digit count to increase a few times before giving up
        end
        return -1 if found            # were not able to find an unused id in the allowed attempts
        test_id
      end

      def self.id_persisted?(test_id)
        # TODO Does ActiveTriples::Resource have a class method to do this test instead of having to instantiate an object and then checking for persistence?
        self.new(test_id).persisted?
      end

      def self.uri_persisted?(test_uri)
        # TODO Does ActiveTriples::Resource have a class method to do this test instead of having to instantiate an object and then checking for persistence?
        test_uri = test_uri.kind_of?(RDF::URI) ? test_uri : RDF::URI(test_uri)
        self.new(test_uri).persisted?
      end

      def get_uri(uri_or_str)
        return uri_or_str.to_uri if uri_or_str.respond_to? :to_uri
        return uri_or_str if uri_or_str.kind_of? RDF::Node
        uri_or_str = uri_or_str.to_s
        return RDF::Node(uri_or_str[2..-1]) if uri_or_str.start_with? '_:'
        return RDF::URI(uri_or_str) if RDF::URI(uri_or_str).valid? and (URI.scheme_list.include?(RDF::URI.new(uri_or_str).scheme.upcase) or RDF::URI.new(uri_or_str).scheme == 'info')
        return RDF::URI(self.base_uri.to_s + (self.base_uri.to_s[-1,1] =~ /(\/|#)/ ? '' : '/') + id_prefix + uri_or_str) if base_uri && !uri_or_str.start_with?(base_uri.to_s)
        raise RuntimeError, "could not make a valid RDF::URI from #{uri_or_str}"
      end

    end
  end
end

