require "spec_helper"

describe "LD4L::OpenAnnotationRDF" do
  describe "#configure" do

    before do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost/test/"
      end
      class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
        configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
      end
    end
    after do
      LD4L::OpenAnnotationRDF.reset
      Object.send(:remove_const, "DummyAnnotation") if Object
    end

    it "should return configured value" do
      config = LD4L::OpenAnnotationRDF.configuration
      expect(config.base_uri).to eq "http://localhost/test/"
    end

    it "should use configured value in Annotation sub-class" do
      oa = DummyAnnotation.new('1')
      expect(oa.rdf_subject.to_s).to eq "http://localhost/test/1"
    end
  end

  describe ".reset" do
    before :each do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost/test/"
      end
    end

    it "resets the configuration" do
      LD4L::OpenAnnotationRDF.reset
      config = LD4L::OpenAnnotationRDF.configuration
      expect(config.base_uri).to eq "http://localhost/"
    end
  end
end