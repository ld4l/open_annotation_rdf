module RDFTypes
  class OpenAnnotationRDF < RDFTypes::ResourceExtension

    @id_prefix="oa"

    configure :type => RDFVocabularies::OA.Annotation, :base_uri => Rails.configuration.urigenerator.base_uri, :repository => :default

    property :hasTarget,   :predicate => RDFVocabularies::OA.hasTarget    # :type => URI
    property :hasBody,     :predicate => RDFVocabularies::OA.hasBody,     :class_name => RDFTypes::OpenAnnotationBodyRDF
    property :annotatedBy, :predicate => RDFVocabularies::OA.annotatedBy, :class_name => RDFTypes::PersonRDF
    property :annotatedAt, :predicate => RDFVocabularies::OA.annotatedAt  # :type => xsd:dateTime    # the time Annotation was created
    property :motivatedBy, :predicate => RDFVocabularies::OA.motivatedBy  # comes from RDFVocabularies::OA ontology
  end
end

