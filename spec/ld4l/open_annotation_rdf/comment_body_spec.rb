require 'spec_helper'

describe 'LD4L::OpenAnnotationRDF::CommentBody' do

  subject { LD4L::OpenAnnotationRDF::CommentBody.new }

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
      expect(subject.rdf_subject).to eq RDF::URI("#{LD4L::OpenAnnotationRDF::CommentBody.base_uri}123")
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
        expect{ subject.set_subject! RDF::URI('http://example.org/moomin2') }.to raise_error(RuntimeError, 'Refusing update URI when one is already assigned!')
      end
    end
  end


  # -------------------------------------------------
  #  START -- Test attributes specific to this model
  # -------------------------------------------------

  describe 'type' do
    it "should be set to text and ContentAsText from new" do
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 2
      expect(expected_results).to include RDF::Vocab::DCMIType.Text
      expect(expected_results).to include RDF::Vocab::CNT.ContentAsText
    end

    it "should be settable" do
      subject.type = RDF::Vocab::DCMIType.Text
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 1
      expect(expected_results).to include RDF::Vocab::DCMIType.Text
    end

    it "should be settable to multiple values" do
      t = [RDF::Vocab::DCMIType.Text, RDF::Vocab::CNT.ContentAsText]
      subject.set_value(:type,t)
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 2
      expect(expected_results).to include RDF::Vocab::DCMIType.Text
      expect(expected_results).to include RDF::Vocab::CNT.ContentAsText
    end

    it "should be changeable" do
      subject.type = RDF::Vocab::DCMIType.Text
      subject.type = RDF::Vocab::CNT.ContentAsText
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 1
      expect(expected_results).to include RDF::Vocab::CNT.ContentAsText
    end

    it "should be changeable for multiple values" do
      t = [RDF::Vocab::DCMIType.Text, RDF::Vocab::CNT.ContentAsText]
      subject.set_value(:type,t)
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 2
      expect(expected_results).to include RDF::Vocab::DCMIType.Text
      expect(expected_results).to include RDF::Vocab::CNT.ContentAsText

      t = subject.get_values(:type).to_a
      t[0] = RDF::Vocab::OA.Tag           # dummy type for testing
      t[1] = RDF::Vocab::OA.SemanticTag   # dummy type for testing
      subject.set_value(:type,t)
      expected_results = subject.type
      expected_results = expected_results.to_a if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
      expect(expected_results.size).to eq 2
      expect(expected_results).to include RDF::Vocab::OA.Tag
      expect(expected_results).to include RDF::Vocab::OA.SemanticTag
    end
  end

  describe 'content' do
    it "should be empty array if we haven't set it" do
      expect(subject.content).to match_array([])
    end

    it "should be settable" do
      subject.content = "bla"
      expect(subject.content).to eq ["bla"]
    end

    it "should be changeable" do
      subject.content = "bla"
      subject.content = "new bla"
      expect(subject.content).to eq ["new bla"]
    end
  end

  describe 'format' do
    it "should be empty array if we haven't set it" do
      expect(subject.format).to match_array([])
    end

    it "should be settable" do
      a_format = "text/rtf"
      subject.format = a_format
      expect(subject.format.first).to eq "text/rtf"
    end

    it "should be changeable" do
      orig_format = "text/plain"
      new_format  = "text/xml"
      subject.format = orig_format
      subject.format = new_format
      expect(subject.format.first).to eq  new_format
    end
  end

  describe '#localname_prefix' do
    it "should return default prefix" do
      prefix = LD4L::OpenAnnotationRDF::CommentBody.localname_prefix
      expect(prefix).to eq "cb"
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
          subject.content = "bla"
          subject.persist!
        end

        it "should return true" do
          expect(subject).to be_persisted
        end

        context "and then modified" do
          before do
            subject.content = "newbla"
          end

          it "should return true" do
            expect(subject).to be_persisted
          end
        end
        context "and then reloaded" do
          before do
            subject.reload
          end

          it "should reset the content" do
            expect(subject.content).to eq ["bla"]
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

        subject {LD4L::OpenAnnotationRDF::CommentBody.new("123")}
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
          subject.content = "bla"
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
          expect(subject.content).to eq ["bla"]
          subject.content = []
          expect(subject.content).to eq []
          subject.persist!
          subject.reload
          expect(subject.content).to eq []
          expect(@repo.statements.to_a.length).to eq 2 # Only the 2 type statements
        end
      end
    end
  end

  describe '#destroy!' do
    before do
      subject << RDF::Statement(RDF::Vocab::DC.LicenseDocument, RDF::Vocab::DC.title, 'LICENSE')
    end

    subject { LD4L::OpenAnnotationRDF::CommentBody.new('456')}

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
    subject {LD4L::OpenAnnotationRDF::CommentBody.new("123")}

    it 'should return an array of label values' do
      expect(subject.rdf_label).to be_kind_of Array
    end

    it 'should return the default label as URI when no title property exists' do
      expect(subject.rdf_label).to eq [RDF::URI("#{LD4L::OpenAnnotationRDF::CommentBody.base_uri}123")]
    end

    it 'should prioritize configured label values' do
      custom_label = RDF::URI('http://example.org/custom_label')
      subject.class.configure :rdf_label => custom_label
      subject << RDF::Statement(subject.rdf_subject, custom_label, RDF::Literal('New Label'))
      expect(subject.rdf_label).to eq ['New Label']
    end
  end

  describe 'editing the graph' do
    it 'should write properties when statements are added' do
      subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::CNT.chars, 'Great book!')
      expect(subject.content).to include 'Great book!'
    end

    it 'should delete properties when statements are removed' do
      subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::CNT.chars, 'Great book!')
      subject.delete RDF::Statement.new(subject.rdf_subject, RDF::Vocab::CNT.chars, 'Great book!')
      expect(subject.content).to eq []
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

      LD4L::OpenAnnotationRDF::CommentBody.property :item, :predicate => RDF::Vocab::DC.relation, :class_name => DummyDocument
    end

    subject { LD4L::OpenAnnotationRDF::CommentBody.new }

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
