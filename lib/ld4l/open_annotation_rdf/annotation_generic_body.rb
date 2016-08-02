module LD4L
  module OpenAnnotationRDF
    class AnnotationGenericBody < ActiveTriples::Resource

      class << self; attr_reader :localname_prefix end
      @localname_prefix="a"

      configure :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri,
                :repository => :default
    end
  end
end
