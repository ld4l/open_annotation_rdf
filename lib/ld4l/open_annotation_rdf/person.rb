require 'rdf'

# TODO: This should not be in the open annotation GEM.  There should be a Person Gem that gets pulled in.
module LD4L
  module OpenAnnotationRDF
    class Person < LD4L::OpenAnnotationRDF::ResourceExtension

      @id_prefix="p"

      configure :type => RDF::FOAF.Person, :base_uri => LD4L::OpenAnnotationRDF.configuration.person_base_uri, :repository => :default
    end
  end
end
