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
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost:3000/s1"
        end
      end

      context "when uri ends with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.base_uri = "http://localhost:3000/test_slash/"
          end
          class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
            configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyAnnotation") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate a Annotation URI using the base_uri" do
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost:3000/test_slash/s1"
        end
      end

      context "when uri does not end with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.base_uri = "http://localhost:3000/test_no_slash"
          end
          class DummyAnnotation < LD4L::OpenAnnotationRDF::Annotation
            configure :type => RDFVocabularies::OA.Annotation, :base_uri => LD4L::OpenAnnotationRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyAnnotation") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate a Annotation URI using the base_uri" do
          expect(DummyAnnotation.new('1').rdf_subject.to_s).to eq "http://localhost:3000/test_no_slash/s1"
        end
      end
    end

    describe "person_base_uri" do
      context "when person_base_uri is not configured" do
        context "and the base_uri is not configured" do
          before do
            class DummyPerson < LD4L::OpenAnnotationRDF::Person
              configure :type => RDF::FOAF.Person, :base_uri => LD4L::OpenAnnotationRDF.configuration.person_base_uri, :repository => :default
            end
          end
          after do
            Object.send(:remove_const, "DummyPerson") if Object
            LD4L::OpenAnnotationRDF.reset
          end

          it "should generate a Person URI using the default base_uri" do
            expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/s1"
          end
        end

        context "and the base_uri is configured" do
          before do
            LD4L::OpenAnnotationRDF.configure do |config|
              config.base_uri = "http://localhost:3000/has_base/"
            end
            class DummyPerson < LD4L::OpenAnnotationRDF::Person
              configure :type => RDF::FOAF.Person, :base_uri => LD4L::OpenAnnotationRDF.configuration.person_base_uri, :repository => :default
            end
          end
          after do
            Object.send(:remove_const, "DummyPerson") if Object
            LD4L::OpenAnnotationRDF.reset
          end

          it "should generate a Person URI using the base_uri" do
            expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/has_base/s1"
          end
        end
      end

      context "when person base uri ends with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.person_base_uri = "http://localhost:3000/person/has_slash/"
          end
          class DummyPerson < LD4L::OpenAnnotationRDF::Person
            configure :type => RDF::FOAF.Person, :base_uri => LD4L::OpenAnnotationRDF.configuration.person_base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyPerson") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate a Person URI using the person_base_uri" do
          expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/person/has_slash/s1"
        end
      end

      context "when person base uri does not end with slash" do
        before do
          LD4L::OpenAnnotationRDF.configure do |config|
            config.person_base_uri = "http://localhost:3000/person/no_slash"
          end
          class DummyPerson < LD4L::OpenAnnotationRDF::Person
            configure :type => RDF::FOAF.Person, :base_uri => LD4L::OpenAnnotationRDF.configuration.person_base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyPerson") if Object
          LD4L::OpenAnnotationRDF.reset
        end

        it "should generate a Person URI using the person_base_uri" do
          expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/person/no_slash/s1"
        end
      end
    end
  end

  describe "LD4L::OpenAnnotationRDF::Configuration" do
    describe "#base_uri" do
      it "should default to localhost" do
        expect(LD4L::OpenAnnotationRDF::Configuration.new.base_uri).to eq "http://localhost:3000/"
      end

      it "should be settable" do
        config = LD4L::OpenAnnotationRDF::Configuration.new
        config.base_uri = "http://localhost:3000/test"
        expect(config.base_uri).to eq "http://localhost:3000/test"
      end
    end

    describe "#person_base_uri" do
      context "when base_uri is not configured" do
        it "should default to localhost" do
          expect(LD4L::OpenAnnotationRDF::Configuration.new.person_base_uri).to eq "http://localhost:3000/"
        end
      end

      context "when base_uri is configured" do
        it "should default to base_uri" do
          config = LD4L::OpenAnnotationRDF::Configuration.new
          config.base_uri = "http://localhost:3000/test"
          expect(config.person_base_uri).to eq "http://localhost:3000/test"
        end
      end

      it "should be settable" do
        config = LD4L::OpenAnnotationRDF::Configuration.new
        config.person_base_uri = "http://localhost:3000/test/person"
        expect(config.person_base_uri).to eq "http://localhost:3000/test/person"
      end
    end
  end

end
