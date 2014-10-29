require 'rdf'
require 'active_triples'
require	'linkeddata'
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


    # RDF vocabularies
    autoload :OA,                    'ld4l/open_annotation_rdf/vocab/oa'
    autoload :CNT,                   'ld4l/open_annotation_rdf/vocab/cnt'
    autoload :DCTYPES,               'ld4l/open_annotation_rdf/vocab/dctypes'


    # autoload classes
    autoload :Configuration,         'ld4l/open_annotation_rdf/configuration'
    autoload :Annotation,            'ld4l/open_annotation_rdf/annotation'
    autoload :CommentAnnotation,     'ld4l/open_annotation_rdf/comment_annotation'
    autoload :CommentBody,           'ld4l/open_annotation_rdf/comment_body'
    autoload :TagAnnotation,         'ld4l/open_annotation_rdf/tag_annotation'
    autoload :SemanticTagAnnotation, 'ld4l/open_annotation_rdf/semantic_tag_annotation'

    def self.class_from_string(class_name, container_class=Kernel)
      container_class = container_class.name if container_class.is_a? Module
      container_parts = container_class.split('::')
      (container_parts + class_name.split('::')).flatten.inject(Kernel) do |mod, class_name|
        if mod == Kernel
          Object.const_get(class_name)
        elsif mod.const_defined? class_name.to_sym
          mod.const_get(class_name)
        else
          container_parts.pop
          class_from_string(class_name, container_parts.join('::'))
        end
      end
    end

  end
end

