require 'spec_helper'

describe 'LD4L::VirtualCollectionRDF' do

  describe '#configuration' do
    describe "base_uri" do
      context "when base_uri is not configured" do
        before do
          class DummyCollection < LD4L::VirtualCollectionRDF::Collection
            configure :type => RDFVocabularies::ORE.Aggregation, :base_uri => LD4L::VirtualCollectionRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyCollection") if Object
        end
        it "should generate a Collection URI using the default base_uri" do
          expect(DummyCollection.new('1').rdf_subject.to_s).to eq "http://localhost:3000/s1"
        end
      end

      context "when uri ends with slash" do
        before do
          LD4L::VirtualCollectionRDF.configure do |config|
            config.base_uri = "http://localhost:3000/test_slash/"
          end
          class DummyCollection < LD4L::VirtualCollectionRDF::Collection
            configure :type => RDFVocabularies::ORE.Aggregation, :base_uri => LD4L::VirtualCollectionRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyCollection") if Object
          LD4L::VirtualCollectionRDF.reset
        end

        it "should generate a Collection URI using the base_uri" do
          expect(DummyCollection.new('1').rdf_subject.to_s).to eq "http://localhost:3000/test_slash/s1"
        end
      end

      context "when uri does not end with slash" do
        before do
          LD4L::VirtualCollectionRDF.configure do |config|
            config.base_uri = "http://localhost:3000/test_no_slash"
          end
          class DummyCollection < LD4L::VirtualCollectionRDF::Collection
            configure :type => RDFVocabularies::ORE.Aggregation, :base_uri => LD4L::VirtualCollectionRDF.configuration.base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyCollection") if Object
          LD4L::VirtualCollectionRDF.reset
        end

        it "should generate a Collection URI using the base_uri" do
          expect(DummyCollection.new('1').rdf_subject.to_s).to eq "http://localhost:3000/test_no_slash/s1"
        end
      end
    end

    describe "person_base_uri" do
      context "when person_base_uri is not configured" do
        context "and the base_uri is not configured" do
          before do
            class DummyPerson < LD4L::VirtualCollectionRDF::Person
              configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
            end
          end
          after do
            Object.send(:remove_const, "DummyPerson") if Object
            LD4L::VirtualCollectionRDF.reset
          end

          it "should generate a Person URI using the default base_uri" do
            expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/s1"
          end
        end

        context "and the base_uri is configured" do
          before do
            LD4L::VirtualCollectionRDF.configure do |config|
              config.base_uri = "http://localhost:3000/has_base/"
            end
            class DummyPerson < LD4L::VirtualCollectionRDF::Person
              configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
            end
          end
          after do
            Object.send(:remove_const, "DummyPerson") if Object
            LD4L::VirtualCollectionRDF.reset
          end

          it "should generate a Person URI using the base_uri" do
            expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/has_base/s1"
          end
        end
      end

      context "when person base uri ends with slash" do
        before do
          LD4L::VirtualCollectionRDF.configure do |config|
            config.person_base_uri = "http://localhost:3000/person/has_slash/"
          end
          class DummyPerson < LD4L::VirtualCollectionRDF::Person
            configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyPerson") if Object
          LD4L::VirtualCollectionRDF.reset
        end

        it "should generate a Person URI using the person_base_uri" do
          expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/person/has_slash/s1"
        end
      end

      context "when person base uri does not end with slash" do
        before do
          LD4L::VirtualCollectionRDF.configure do |config|
            config.person_base_uri = "http://localhost:3000/person/no_slash"
          end
          class DummyPerson < LD4L::VirtualCollectionRDF::Person
            configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
          end
        end
        after do
          Object.send(:remove_const, "DummyPerson") if Object
          LD4L::VirtualCollectionRDF.reset
        end

        it "should generate a Person URI using the person_base_uri" do
          expect(DummyPerson.new('1').rdf_subject.to_s).to eq "http://localhost:3000/person/no_slash/s1"
        end
      end
    end
  end

  describe "LD4L::VirtualCollectionRDF::Configuration" do
    describe "#base_uri" do
      it "should default to localhost" do
        expect(LD4L::VirtualCollectionRDF::Configuration.new.base_uri).to eq "http://localhost:3000/"
      end

      it "should be settable" do
        config = LD4L::VirtualCollectionRDF::Configuration.new
        config.base_uri = "http://localhost:3000/test"
        expect(config.base_uri).to eq "http://localhost:3000/test"
      end
    end

    describe "#person_base_uri" do
      context "when base_uri is not configured" do
        it "should default to localhost" do
          expect(LD4L::VirtualCollectionRDF::Configuration.new.person_base_uri).to eq "http://localhost:3000/"
        end
      end

      context "when base_uri is configured" do
        it "should default to base_uri" do
          config = LD4L::VirtualCollectionRDF::Configuration.new
          config.base_uri = "http://localhost:3000/test"
          expect(config.person_base_uri).to eq "http://localhost:3000/test"
        end
      end

      it "should be settable" do
        config = LD4L::VirtualCollectionRDF::Configuration.new
        config.person_base_uri = "http://localhost:3000/test/person"
        expect(config.person_base_uri).to eq "http://localhost:3000/test/person"
      end
    end
  end

end
