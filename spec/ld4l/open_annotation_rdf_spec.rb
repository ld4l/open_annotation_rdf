require "spec_helper"

describe "LD4L::VirtualCollectionRDF" do
  describe "#configure" do

    before :each do
      LD4L::VirtualCollectionRDF.configure do |config|
        config.base_uri = "http://localhost:3000/test/"
      end
    end

    it "should return configured value" do
      config = LD4L::VirtualCollectionRDF.configuration
      expect(config.base_uri).to eq "http://localhost:3000/test/"
    end

    it "should use configured value in Collection class" do
      # FIXME fails if run with all tests because LD4L::VirtualCollectionRDF::Collection is already loaded by other tests
      vc = LD4L::VirtualCollectionRDF::Collection.new('1')
      expect(vc.rdf_subject.to_s).to eq "http://localhost:3000/test/vc1"
    end

    after :each do
      LD4L::VirtualCollectionRDF.reset
    end
  end

  describe ".reset" do
    before :each do
      LD4L::VirtualCollectionRDF.configure do |config|
        config.base_uri = "http://localhost:3000/test/"
      end
    end

    it "resets the configuration" do
      LD4L::VirtualCollectionRDF.reset

      config = LD4L::VirtualCollectionRDF.configuration

      expect(config.base_uri).to eq "http://localhost:3000/"
    end
  end
end