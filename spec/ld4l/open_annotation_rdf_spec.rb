require "spec_helper"

describe "LD4L::OpenAnnotationRDF" do
  describe "#configure" do

    before do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost/test/"
        config.localname_minter = lambda { |prefix=""| prefix+'_configured_'+SecureRandom.uuid }
        config.unique_tags = false
      end
      class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
        configure :type => RDF::Vocab::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
      end
    end
    after do
      LD4L::OpenAnnotationRDF.reset
      Object.send(:remove_const, "DummyAnnotation") if Object
    end

    it "should return configured value" do
      config = LD4L::OpenAnnotationRDF.configuration
      expect(config.base_uri).to eq "http://localhost/test/"
      expect(config.localname_minter).to be_kind_of Proc
      expect(config.unique_tags).to be false
    end

    it "should use configured value in DummyAnnotation" do
      oa = DummyAnnotation.new('1')
      expect(oa.rdf_subject.to_s).to eq "http://localhost/test/1"

      oa = DummyAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
                                   LD4L::OpenAnnotationRDF::Annotation, 10, 'foo',
                                   &LD4L::OpenAnnotationRDF.configuration.localname_minter ))
      expect(oa.rdf_subject.to_s.size).to eq 73
      expect(oa.rdf_subject.to_s).to match /http:\/\/localhost\/test\/foo_configured_[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
    end
  end

  describe ".reset" do
    before :each do
      LD4L::OpenAnnotationRDF.configure do |config|
        config.base_uri = "http://localhost/test/"
        config.localname_minter = lambda { |prefix=""| prefix+'_configured_'+SecureRandom.uuid }
        config.unique_tags = false
      end
    end

    it "resets the configuration" do
      LD4L::OpenAnnotationRDF.reset
      config = LD4L::OpenAnnotationRDF.configuration
      expect(config.base_uri).to eq "http://localhost/"
      expect(config.localname_minter).to eq nil
      expect(config.unique_tags).to be true
    end
  end
end