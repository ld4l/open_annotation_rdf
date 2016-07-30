require 'rdf'
require 'active_triples'
require 'active_triples/local_name'
require	'linkeddata'
require 'ld4l/foaf_rdf'
require 'ld4l/open_annotation_rdf/version'


module LD4L
  module OpenAnnotationRDF

    # Methods for configuring the GEM
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    # autoload classes
    autoload :Configuration,         'ld4l/open_annotation_rdf/configuration'
    autoload :Annotation,            'ld4l/open_annotation_rdf/annotation'
    autoload :CommentAnnotation,     'ld4l/open_annotation_rdf/comment_annotation'
    autoload :CommentBody,           'ld4l/open_annotation_rdf/comment_body'
    autoload :TagAnnotation,         'ld4l/open_annotation_rdf/tag_annotation'
    autoload :TagBody,               'ld4l/open_annotation_rdf/tag_body'
    autoload :SemanticTagAnnotation, 'ld4l/open_annotation_rdf/semantic_tag_annotation'
    autoload :SemanticTagBody,       'ld4l/open_annotation_rdf/semantic_tag_body'
  end
end

