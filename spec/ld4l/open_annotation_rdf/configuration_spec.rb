require 'spec_helper'

describe 'LD4L::OpenAnnotationRDF' do

  describe '#configuration' do
    describe "base_uri" do
      context "when base_uri is not configured" do
        before do
          class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
            configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyAnnotation") if Object
        end
        it "should generate a Annotation URI using the default base_uri" do
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost/1"
        end
      end

      context "when uri ends with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.base_uri = "http://localhost/test_slash/"
          end
          class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
            configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyAnnotation") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate an Annotation URI using the configured base_uri" do
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost/test_slash/1"
        end
      end

      context "when uri does not end with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.base_uri = "http://localhost/test_no_slash"
          end
          class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
            configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyAnnotation") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate an Annotation URI using the configured base_uri" do
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost/test_no_slash/1"
        end
      end

      it "should return value of configured base_uri" do
        LD4L::OpenAnnotationRDF.configure do |config|
          config.base_uri = "http://localhost/test_config/"
        end
        expect(LD4L::OpenAnnotationRDF.configuration.base_uri).to eq "http://localhost/test_config/"
      end

      it "should return default base_uri when base_uri is reset" do
        LD4L::OpenAnnotationRDF.configure do |config|
          config.base_uri = "http://localhost/test_config/"
        end
        expect(LD4L::OpenAnnotationRDF.configuration.base_uri).to eq "http://localhost/test_config/"
        LD4L::OpenAnnotationRDF.configuration.reset_base_uri
        expect(LD4L::OpenAnnotationRDF.configuration.base_uri).to eq "http://localhost/"
      end

      it "should return default base_uri when all configs are reset" do
        LD4L::OpenAnnotationRDF.configure do |config|
          config.base_uri = "http://localhost/test_config/"
        end
        expect(LD4L::OpenAnnotationRDF.configuration.base_uri).to eq "http://localhost/test_config/"
        LD4L::OpenAnnotationRDF.reset
        expect(LD4L::OpenAnnotationRDF.configuration.base_uri).to eq "http://localhost/"
      end
    end
  end


  describe "LD4L::OpenAnnotationRDF::Configuration" do
    describe "#base_uri" do
      it "should default to localhost" do
        expect(LD4L::OpenAnnotationRDF::Configuration.new.base_uri).to eq "http://localhost/"
      end

      it "should be settable" do
        config = LD4L::OpenAnnotationRDF::Configuration.new
        config.base_uri = "http://localhost/test"
        expect(config.base_uri).to eq "http://localhost/test"
      end

      it "should be re-settable" do
        config = LD4L::OpenAnnotationRDF::Configuration.new
        config.base_uri = "http://localhost/test/again"
        expect(config.base_uri).to eq "http://localhost/test/again"
        config.reset_base_uri
        expect(config.base_uri).to eq "http://localhost/"
      end
    end
  end
end
