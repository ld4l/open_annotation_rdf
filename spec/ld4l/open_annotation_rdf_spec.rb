require "spec_helper"

describe "LD4L::OpenAnnotationRDF" do
  describe "#configure" do

    before :each do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost:3000/test/"
      end
    end

    it "should return configured value" do
      config = LD4L::OpenAnnotationRDF.configuration
      expect(config.base_uri).to eq "http://localhost:3000/test/"
    end

    it "should use configured value in Annotation class" do
      # FIXME fails if run with all tests because LD4L::OpenAnnotationRDF::Annotation is already loaded by other tests
      vc = LD4L::OpenAnnotationRDF::Annotation.new('1')
      expect(vc.rdf_subject.to_s).to eq "http://localhost:3000/test/vc1"
    end

    after :each do
      LD4L::OpenAnnotationRDF.reset
    end
  end

  describe ".reset" do
    before :each do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost:3000/test/"
      end
    end

    it "resets the configuration" do
      LD4L::OpenAnnotationRDF.reset

      config = LD4L::OpenAnnotationRDF.configuration

      expect(config.base_uri).to eq "http://localhost:3000/"
    end
  end
end