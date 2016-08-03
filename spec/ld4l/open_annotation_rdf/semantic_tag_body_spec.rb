require 'spec_helper'

describe 'LD4L::OpenAnnotationRDF::SemanticTagBody' do

  after do
    ActiveTriples::Repositories.repositories[LD4L::OpenAnnotationRDF::CommentAnnotation.repository].clear!
  end

  subject { LD4L::OpenAnnotationRDF::SemanticTagBody.new }

  describe 'rdf_subject' do
    it "should be a blank node if we haven't set it" do
      expect(subject.rdf_subject.node?).to be true
    end

    it "should be settable when it has not been set yet" do
      subject.set_subject! RDF::URI('http://example.org/moomin')
      expect(subject.rdf_subject).to eq RDF::URI('http://example.org/moomin')
    end

    it "should append to base URI when setting to non-URI subject" do
      subject.set_subject! '123'
      expect(subject.rdf_subject).to eq RDF::URI("#{LD4L::OpenAnnotationRDF::SemanticTagBody.base_uri}123")
    end

    describe 'when changing subject' do
      before do
        subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::DC.title, RDF::Literal('Comet in Moominland'))
        subject << RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.isPartOf, subject.rdf_subject)
        subject << RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.relation, 'http://example.org/moomin_land')
        subject.set_subject! RDF::URI('http://example.org/moomin')
      end

      it 'should update graph subjects' do
        expect(subject.has_statement?(RDF::Statement.new(subject.rdf_subject, RDF::Vocab::DC.title, RDF::Literal('Comet in Moominland')))).to be true
      end

      it 'should update graph objects' do
        expect(subject.has_statement?(RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.isPartOf, subject.rdf_subject))).to be true
      end

      it 'should leave other uris alone' do
        expect(subject.has_statement?(RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.relation, 'http://example.org/moomin_land'))).to be true
      end
    end

    describe 'created with URI subject' do
      before do
        subject.set_subject! RDF::URI('http://example.org/moomin')
      end

      it 'should not be settable' do
        expect{ subject.set_subject! RDF::URI('http://example.org/moomin2') }.to raise_error(RuntimeError, 'Refusing to update URI when one is already assigned!')
      end
    end
  end


  # -------------------------------------------------
  #  START -- Test attributes specific to this model
  # -------------------------------------------------

  describe 'type' do
    it "should be set to text and astext from new" do
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 1
      expect(expected_results).to include RDF::Vocab::OA.SemanticTag
    end
  end

  describe '#localname_prefix' do
    it "should return default prefix" do
      prefix = LD4L::OpenAnnotationRDF::SemanticTagBody.localname_prefix
      expect(prefix).to eq "stb"
    end
  end

  describe "#annotations_using" do

    context "when term value is nil" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using(nil) }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when term value is a string of 0 length" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using("") }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when term is not a string or uri" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using(3) }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when terms exist in the repository" do
      before do
        # Create inmemory repository
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('http://example.org/sta1')
        sta.setTerm(RDF::URI("http://example.org/EXISTING_term"))
        sta.persist!
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('http://example.org/sta2')
        sta.setTerm(RDF::URI("http://example.org/EXISTING_term"))
        sta.persist!
        stb = LD4L::OpenAnnotationRDF::SemanticTagBody.new('http://example.org/UNUSED_term')
        stb.persist!
      end

      context "and term is passed as string URI" do
        it "should find annotations using the term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using('http://example.org/EXISTING_term')
          expect( annotations.include?(RDF::URI('http://example.org/sta1')) ).to be true
          expect( annotations.include?(RDF::URI('http://example.org/sta2')) ).to be true
          expect( annotations.size ).to be 2
        end

        it "should find 0 annotations for unused term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using('http://example.org/UNUSED_term')
          expect( annotations ).to eq []
        end

        it "should find 0 annotations for non-existent term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using('http://example.org/NONEXISTING_term')
          expect( annotations ).to eq []
        end
      end

      context "and term is passed as RDF::URI" do
        it "should find annotations using the term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using(RDF::URI('http://example.org/EXISTING_term'))
          expect( annotations.include?(RDF::URI('http://example.org/sta1')) ).to be true
          expect( annotations.include?(RDF::URI('http://example.org/sta2')) ).to be true
          expect( annotations.size ).to be 2
        end

        it "should find 0 annotations for unused term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using(RDF::URI('http://example.org/UNUSED_term'))
          expect( annotations ).to eq []
        end

        it "should find 0 annotations for non-existent term" do
          annotations = LD4L::OpenAnnotationRDF::SemanticTagBody.annotations_using(RDF::URI'http://example.org/NONEXISTING_term')
          expect( annotations ).to eq []
        end
      end
    end
  end

  describe "#destroy_if_unused" do
    context "when term is nil" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused(nil) }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when term is a string of 0 length" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused("") }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when term is not a string or uri" do
      it "should throw invalid arguement exception" do
        expect{ LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused(3) }.to raise_error(ArgumentError, 'Argument must be a uri string or an instance of RDF::URI')
      end
    end

    context "when terms exist in the repository" do
      before do
        # Create inmemory repository
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('http://example.org/sta1')
        sta.setTerm(RDF::URI("http://example.org/EXISTING_term"))
        sta.persist!
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('http://example.org/sta2')
        sta.setTerm(RDF::URI("http://example.org/EXISTING_term"))
        sta.persist!
        stb = LD4L::OpenAnnotationRDF::SemanticTagBody.new('http://example.org/UNUSED_term')
        stb.persist!
      end

      context "and term is passed as string URI" do
        it "should not destroy if used by any annotations" do
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused('http://example.org/EXISTING_term') ).to be false
        end

        it "should destory if not used by any annotations" do
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused('http://example.org/UNUSED_term') ).to be true
        end

        it "will destory if term doesn't exist" do
          # NOTE: ActiveTriples.destroy! persists the object to be destroyed before destroying it
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused('http://example.org/NONEXISTENT_term') ).to be true
        end
      end

      context "and term is passed as RDF::URI" do
        it "should not destroy if used by any annotations" do
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused(RDF::URI('http://example.org/EXISTING_term')) ).to be false
        end

        it "should destory if not used by any annotations" do
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused(RDF::URI('http://example.org/UNUSED_term')) ).to be true
        end

        it "will destory if term doesn't exist" do
          # NOTE: ActiveTriples.destroy! persists the object to be destroyed before destroying it
          expect( LD4L::OpenAnnotationRDF::SemanticTagBody.destroy_if_unused(RDF::URI('http://example.org/NONEXISTENT_term')) ).to be true
        end
      end
    end
  end

  # -----------------------------------------------
  #  END -- Test attributes specific to this model
  # -----------------------------------------------


  describe "#persisted?" do
    context 'with a repository' do
      before do
        # Create inmemory repository
        repository = RDF::Repository.new
        allow(subject).to receive(:repository).and_return(repository)
      end

      context "when the object is new" do
        it "should return false" do
          expect(subject).not_to be_persisted
        end
      end

      context "when it is saved" do
        before do
          subject.persist!
        end

        it "should return true" do
          expect(subject).to be_persisted
        end

        context "and then reloaded" do
          before do
            subject.reload
          end

          it "should be persisted" do
            expect(subject).to be_persisted
          end
        end
      end
    end
  end

  describe "#persist!" do
    context "when the repository is set" do
      context "and the item is not a blank node" do

        subject {LD4L::OpenAnnotationRDF::SemanticTagBody.new("123")}
        let(:result) { subject.persist! }

        before do
          # Create inmemory repository
          @repo = RDF::Repository.new
          allow(subject.class).to receive(:repository).and_return(nil)
          if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
            allow(subject.persistence_strategy).to receive(:repository).and_return(@repo)
          else  # < ActiveTriples 0.8
            allow(subject).to receive(:repository).and_return(@repo)
          end
          result
        end

        it "should return true" do
          expect(result).to eq true
        end

        it "should persist to the repository" do
          expect(@repo.statements.first).to eq subject.statements.first
        end

        it "should delete from the repository" do
          subject.reload
          subject.persist!
          subject.reload
          expect(@repo.statements.to_a.length).to eq 1 # Only the 1 type statements
        end
      end
    end
  end

  describe '#destroy!' do
    before do
      subject << RDF::Statement(RDF::Vocab::DC.LicenseDocument, RDF::Vocab::DC.title, 'LICENSE')
    end

    subject { LD4L::OpenAnnotationRDF::SemanticTagBody.new('456')}

    it 'should return true' do
      expect(subject.destroy!).to be true
      expect(subject.destroy).to be true
    end

    it 'should delete the graph' do
      subject.destroy
      expect(subject).to be_empty
    end
  end

  describe '#rdf_label' do
    subject {LD4L::OpenAnnotationRDF::SemanticTagBody.new("123")}

    it 'should return an array of label values' do
      expect(subject.rdf_label).to be_kind_of Array
    end

    it 'should return the default label as URI when no title property exists' do
      expect(subject.rdf_label).to eq [RDF::URI("#{LD4L::OpenAnnotationRDF::SemanticTagBody.base_uri}123")]
    end

    it 'should prioritize configured label values' do
      custom_label = RDF::URI('http://example.org/custom_label')
      subject.class.configure :rdf_label => custom_label
      subject << RDF::Statement(subject.rdf_subject, custom_label, RDF::Literal('New Label'))
      expect(subject.rdf_label).to eq ['New Label']
    end
  end

  describe 'big complex graphs' do
    before do
      class DummyPerson < ActiveTriples::Resource
        configure :type => RDF::URI('http://example.org/Person')
        property :foafname, :predicate => RDF::Vocab::FOAF.name
        property :publications, :predicate => RDF::Vocab::FOAF.publications, :class_name => 'DummyDocument'
        property :knows, :predicate => RDF::Vocab::FOAF.knows, :class_name => DummyPerson
      end

      class DummyDocument < ActiveTriples::Resource
        configure :type => RDF::URI('http://example.org/Document')
        property :title, :predicate => RDF::Vocab::DC.title
        property :creator, :predicate => RDF::Vocab::DC.creator, :class_name => 'DummyPerson'
      end

      LD4L::OpenAnnotationRDF::SemanticTagBody.property :item, :predicate => RDF::Vocab::DC.relation, :class_name => DummyDocument
    end

    subject { LD4L::OpenAnnotationRDF::SemanticTagBody.new }

    let (:document1) do
      d = DummyDocument.new
      d.title = 'Document One'
      d
    end

    let (:document2) do
      d = DummyDocument.new
      d.title = 'Document Two'
      d
    end

    let (:person1) do
      p = DummyPerson.new
      p.foafname = 'Alice'
      p
    end

    let (:person2) do
      p = DummyPerson.new
      p.foafname = 'Bob'
      p
    end

    let (:data) { <<END
_:1 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://example.org/SomeClass> .
_:1 <http://purl.org/dc/terms/relation> _:2 .
_:2 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://example.org/Document> .
_:2 <http://purl.org/dc/terms/title> "Document One" .
_:2 <http://purl.org/dc/terms/creator> _:3 .
_:2 <http://purl.org/dc/terms/creator> _:4 .
_:4 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://example.org/Person> .
_:4 <http://xmlns.com/foaf/0.1/name> "Bob" .
_:3 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://example.org/Person> .
_:3 <http://xmlns.com/foaf/0.1/name> "Alice" .
_:3 <http://xmlns.com/foaf/0.1/knows> _:4 ."
END
    }

    after do
      Object.send(:remove_const, "DummyDocument")
      Object.send(:remove_const, "DummyPerson")
    end

    it 'should allow access to deep nodes' do
      document1.creator = [person1, person2]
      document2.creator = person1
      person1.knows = person2
      person2.knows = person1
      subject.item = [document1]
      expect(subject.item.first.creator.first.knows.first.foafname)
          .to satisfy { |names| ['Alice', 'Bob'].include? names.first }
    end
  end
end
