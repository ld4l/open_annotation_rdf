module LD4L
  module OpenAnnotationRDF
    class Annotation < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="oa"

      @body = nil

      configure :type => RDF::Vocab::OA.Annotation,
                :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default

      property :hasTarget,   :predicate => RDF::Vocab::OA.hasTarget    # :type => URI
      property :hasBody,     :predicate => RDF::Vocab::OA.hasBody
      property :annotatedBy, :predicate => RDF::Vocab::OA.annotatedBy, :class_name => LD4L::FoafRDF::Person
      property :annotatedAt, :predicate => RDF::Vocab::OA.annotatedAt, :cast => false   # :type => xsd:dateTime    # the time Annotation was created
      property :motivatedBy, :predicate => RDF::Vocab::OA.motivatedBy, :cast => false   # comes from RDF::Vocab::OA ontology

      def self.resume(uri_or_str)
        # Let ActiveTriples::Resource validate uri_or_str when creating new Annotation
        a = new(uri_or_str)
        return nil if a.nil?

        # currently only support commenting and tagging
        m = motivated_by a
        return LD4L::OpenAnnotationRDF::CommentAnnotation.new(uri_or_str) if m.include? RDF::Vocab::OA.commenting

        # Tagging can be TagAnnotation or SemanticTagAnnotation.  Only way to tell is by checking type of body.
        return a unless m.include? RDF::Vocab::OA.tagging
        b = body_resource a
        return LD4L::OpenAnnotationRDF::TagAnnotation.new(uri_or_str) if b.type.include? RDF::Vocab::OA.Tag
        LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new(uri_or_str)
      end

      ##
      # Get the <tt>ActiveTriples::Resource</tt> instance holding the body of this annotation.
      #
      # @param [String] tag value
      #
      # @return instance of an annotation body if one is set; otherwise, nil
      def getBody
        @body
      end

      ##
      # Set annotatedAt property to now.
      #
      # @return the value of annotatedAt property
      def setAnnotatedAtNow
        set_value(:annotatedAt, Time.now.utc.iso8601(0))
      end

      ##
      # Save all annotation and annotation body triples to the triple store.
      #
      # @return true if annotation successfully persisted; otherwise, false
      #
      # @todo What to return if annotation persists fine, but body fails to persist?
      def persist!
        persisted = super                                               # persist annotation
        body_persisted = persisted && @body ? @body.persist! : false    # persist body
        persisted
      end

      ##
      # Find annotation by target.
      #
      # @param [String, RDF::URI] uri for the work
      #
      # @return true if annotation successfully persisted; otherwise, false
      #
      # @todo What to return if annotation persists fine, but body fails to persist?
      def self::find_by_target(target_uri)
        raise ArgumentError, 'target_uri argument must be a uri string or an instance of RDF::URI'  unless
            target_uri.kind_of?(String) && target_uri.size > 0 || target_uri.kind_of?(RDF::URI)

        # raise ArgumentError, 'repository argument must be an instance of RDF::Repository'  unless
        #     repository.kind_of?(RDF::Repository)

        target_uri = RDF::URI(target_uri) unless target_uri.kind_of?(RDF::URI)

        repo = ActiveTriples::Repositories.repositories[repository]
        query = RDF::Query.new({
                                   :annotation => {
                                       RDF.type =>  RDF::Vocab::OA.Annotation,
                                       RDF::Vocab::OA.hasTarget => target_uri,
                                   }
                               })
        annotations = []
        results = query.execute(repo)
        results.each { |r| annotations << r.to_hash[:annotation] }
        annotations
      end

      private
        def self::motivated_by annotation
          m = annotation.get_values(:motivatedBy).to_a
          return nil unless m.kind_of?(Array) && (m.size > 0)
          m
        end

        def self::body_resource annotation
          body_uris = annotation.hasBody
          return nil if body_uris.nil? || body_uris.size < 1
          AnnotationGenericBody.new(body_uris.first)  # TODO: a full implementation of OA could have multiple bodies
        end
    end
  end
end

