require 'spec_helper'

describe 'LD4L::OpenAnnotationRDF::Annotation' do

  after do
    ActiveTriples::Repositories.repositories[LD4L::OpenAnnotationRDF::CommentAnnotation.repository].clear!
  end

  subject { LD4L::OpenAnnotationRDF::Annotation.new }

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
      expect(subject.rdf_subject).to eq RDF::URI("#{LD4L::OpenAnnotationRDF::Annotation.base_uri}123")
    end

    describe 'when changing subject' do
      before do
        subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::DC.title, RDF::Literal('Comet in Moominland'))
        subject << RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.isPartOf, subject.rdf_subject)
        subject << RDF::Statement.new(RDF::URI('http://example.org/moomin_comics'), RDF::Vocab::DC.relation, 'http://example.org/moomin_land')
        subject.set_subject! RDF::URI('http://example.org/moomin')
      end

      after do
        LD4L::OpenAnnotationRDF.send(:remove_const, :Annotation)
        load 'ld4l/open_annotation_rdf/annotation.rb'
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
    it "should be an RDF::Vocab::OA.Annotation" do
      expect(subject.type.first.value).to eq RDF::Vocab::OA.Annotation.value
    end
  end

  describe 'hasTarget' do
    it "should be empty array if we haven't set it" do
      expect(subject.hasTarget).to match_array([])
    end

    it "should be settable" do
      subject.hasTarget = RDF::URI("http://example.org/b123")
      expect(subject.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/b123"
    end

    it "should be changeable" do
      subject.hasTarget = RDF::URI("http://example.org/b123")
      subject.hasTarget = RDF::URI("http://example.org/b123_NEW")
      expect(subject.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/b123_NEW"
    end
  end

  describe 'hasBody' do
    it "should be empty array if we haven't set it" do
      expect(subject.hasBody).to match_array([])
    end

    it "should be settable" do
      a_open_annotation_body = LD4L::OpenAnnotationRDF::CommentBody.new('1')
      subject.hasBody = a_open_annotation_body
      expect(subject.hasBody.first).to eq a_open_annotation_body
    end

    it "should be changeable" do
      orig_open_annotation_body = LD4L::OpenAnnotationRDF::CommentBody.new('1')
      new_open_annotation_body = LD4L::OpenAnnotationRDF::CommentBody.new('2')
      subject.hasBody = orig_open_annotation_body
      subject.hasBody = new_open_annotation_body
      expect(subject.hasBody.first).to eq new_open_annotation_body
    end
  end

  describe 'annotatedBy' do
    it "should be empty array if we haven't set it" do
      expect(subject.annotatedBy).to match_array([])
    end

    it "should be settable" do
      a_person = LD4L::FoafRDF::Person.new('1')
      subject.annotatedBy = a_person
      expect(subject.annotatedBy.first).to eq a_person
    end

    it "should be changeable" do
      orig_person = LD4L::FoafRDF::Person.new('1')
      new_person = LD4L::FoafRDF::Person.new('2')
      subject.annotatedBy = orig_person
      subject.annotatedBy = new_person
      expect(subject.annotatedBy.first).to eq new_person
    end
  end

  describe 'annotatedAt' do
    it "should be empty array if we haven't set it" do
      expect(subject.annotatedAt).to match_array([])
    end

    it "should be settable" do
      a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
      subject.annotatedAt = a_time
      expect(subject.annotatedAt.first).to eq a_time
    end

    it "should be changeable" do
      orig_time = Time.local(2014, 6, 1, 8, 30).strftime("%Y-%m-%dT%H:%M:%S.%L%z")
      new_time = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
      subject.annotatedAt = orig_time
      subject.annotatedAt = new_time
      expect(subject.annotatedAt.first).to eq new_time
    end
  end

  describe 'motivatedBy' do
    it "should be empty array if we haven't set it" do
      expect(subject.motivatedBy).to match_array([])
    end

    it "should be settable" do
      subject.motivatedBy = RDF::Vocab::OA.describing
      expect(subject.motivatedBy.first).to eq RDF::Vocab::OA.describing
    end

    it "should be changeable" do
      subject.motivatedBy = RDF::Vocab::OA.describing
      subject.motivatedBy = RDF::Vocab::OA.classifying
      expect(subject.motivatedBy.first).to eq RDF::Vocab::OA.classifying
    end
  end

  describe '#localname_prefix' do
    it "should return default prefix" do
      prefix = LD4L::OpenAnnotationRDF::Annotation.localname_prefix
      expect(prefix).to eq "oa"
    end
  end

  describe '#resume' do
    let(:a_person) do
      LD4L::FoafRDF::Person.new('p4')
    end

    context "when annotation body is persisted" do
      it "should resume an instance of CommentAnnotation and its body" do
        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new('ca_1')
        ca.hasTarget = RDF::URI("http://example.org/bibref/br3")
        ca.setComment("This is a comment.")
        ca.annotatedBy = a_person
        ca.annotatedAt = a_time
        ca.persist!
        expect(ca).to be_persisted
        uri = ca.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::CommentAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.commenting

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::CommentBody)
        expect(b.type).to include RDF::Vocab::DCMIType.Text
        expect(b.type).to include RDF::Vocab::CNT.ContentAsText
        expect(b.content).to eq ["This is a comment."]
        expect(b.format.first).to eq "text/plain"
      end

      it "should resume an instance of TagAnnotation and its body" do
        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        ta = LD4L::OpenAnnotationRDF::TagAnnotation.new('ta_2')
        ta.hasTarget = RDF::URI("http://example.org/bibref/br3")
        ta.setTag("good")
        ta.annotatedBy = a_person
        ta.annotatedAt = a_time
        ta.persist!
        expect(ta).to be_persisted
        uri = ta.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::TagAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.tagging

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::TagBody)
        expect(b.type).to include RDF::Vocab::OA.Tag
        expect(b.type).to include RDF::Vocab::CNT.ContentAsText
        expect(b.tag).to eq ["good"]
      end

      it "should resume an instance of SemanticTagAnnotation and its body" do
        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('sta_3')
        sta.hasTarget = RDF::URI("http://example.org/bibref/br3")
        sta.setTerm('http://example.org/term/3')
        sta.annotatedBy = a_person
        sta.annotatedAt = a_time
        sta.persist!
        expect(sta).to be_persisted
        uri = sta.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::SemanticTagAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.tagging

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::SemanticTagBody)
        expect(b.type).to include RDF::Vocab::OA.SemanticTag
        expect(b.rdf_subject.to_s).to eq('http://example.org/term/3')
      end
    end

    context "when annotation body is a blank node" do
      it "should resume an instance of CommentAnnotation and a blank node body" do
        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new('ca_1')
        ca.hasTarget = RDF::URI("http://example.org/bibref/br3")

        cb = LD4L::OpenAnnotationRDF::CommentBody.new    # create body as blank node
        cb.content = "BLANK NODE COMMENT"
        cb.format  = "text/plain"
        cb.persist!
        expect(cb).to be_persisted

        ca.hasBody = cb
        ca.annotatedBy = a_person
        ca.annotatedAt = a_time
        ca.persist!
        expect(ca).to be_persisted
        uri = ca.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::CommentAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.commenting

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::CommentBody)
        expect(b.type).to include RDF::Vocab::DCMIType.Text
        expect(b.type).to include RDF::Vocab::CNT.ContentAsText
        expect(b.content).to eq ["BLANK NODE COMMENT"]
        expect(b.format.first).to eq "text/plain"
      end

      it "should resume an instance of TagAnnotation and a blank node body" do
        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        ta = LD4L::OpenAnnotationRDF::TagAnnotation.new('ta_4')
        ta.hasTarget = RDF::URI("http://example.org/bibref/br3")
        ta.annotatedBy = a_person
        ta.annotatedAt = a_time

        tb = LD4L::OpenAnnotationRDF::TagBody.new    # create body as blank node
        tb.tag = "BLANK_NODE_TAG"
        tb.persist!
        expect(tb).to be_persisted

        ta.hasBody = tb
        ta.persist!
        expect(ta).to be_persisted
        uri = ta.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::TagAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.tagging

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::TagBody)
        expect(b.type).to include RDF::Vocab::OA.Tag
        expect(b.type).to include RDF::Vocab::CNT.ContentAsText
        expect(b.tag).to eq ["BLANK_NODE_TAG"]
      end

      it "should resume an instance of SemanticTagAnnotation and body object is missing" do


        # SKIPPED FOR REWRITE FOR BLANK NODE
        # pending ("rewrite for blank node")


        a_time = Time::now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
        sta = LD4L::OpenAnnotationRDF::SemanticTagAnnotation.new('sta_3')
        sta.hasTarget = RDF::URI("http://example.org/bibref/br3")
        sta.hasBody = RDF::URI('http://example.org/term/3')     # don't create a cooresponding body object
        sta.annotatedBy = a_person
        sta.annotatedAt = a_time
        sta.persist!
        expect(sta).to be_persisted
        uri = sta.rdf_subject

        a = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        expect(a).to be_a_kind_of(LD4L::OpenAnnotationRDF::SemanticTagAnnotation)
        expect(a.hasTarget.first.rdf_subject.to_s).to eq "http://example.org/bibref/br3"
        expect(a.annotatedBy.first).to eq a_person
        expect(a.annotatedAt.first).to eq a_time
        expect(a.motivatedBy.first).to eq RDF::Vocab::OA.tagging

        b = a.getBody
        expect(b).to be_a_kind_of(LD4L::OpenAnnotationRDF::SemanticTagBody)
        expect(b.type).to include RDF::Vocab::OA.SemanticTag
        expect(b.rdf_subject.to_s).to eq('http://example.org/term/3')
      end
    end

    context "when loading from graph" do
      context "and has blank node for body" do
        context "and triples represent a comment annotation" do
          before(:each) do
            @anno_url = "http://my_oa_store/COMMENT_ANNO"
            @comment_value = "This is a comment."
            ttl = "<#{@anno_url}> a <http://www.w3.org/ns/oa#Annotation>;
                     <http://www.w3.org/ns/oa#hasBody> [
                       a <http://purl.org/dc/dcmitype/Text>,
                         <http://www.w3.org/2011/content#ContentAsText>;
                       <http://www.w3.org/2011/content#chars> \"#{@comment_value}\" ;
                       <http://purl.org/dc/terms/format> \"text/plain\"
                     ];
                   <http://www.w3.org/ns/oa#hasTarget> <http://searchworks.stanford.edu/view/666>;
                   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> ."

            anno_graph = RDF::Graph.new.from_ttl ttl
            r = ActiveTriples::Repositories.repositories[:default]
            r << anno_graph
            anno_uri = RDF::URI.new(@anno_url)
            @comment_anno = LD4L::OpenAnnotationRDF::Annotation.resume(anno_uri)
          end
          it "populates LD4L::OpenAnnotationRDF::CommentAnnotation properly" do
            expect(@comment_anno.rdf_subject.to_s).to eq @anno_url
            expect(@comment_anno).to be_a LD4L::OpenAnnotationRDF::CommentAnnotation
            expect(@comment_anno.type).to include(RDF::Vocab::OA.Annotation)
            expect(@comment_anno.motivatedBy).to include(RDF::Vocab::OA.commenting)
            expect(@comment_anno.hasTarget.first.rdf_subject).to eq RDF::URI.new("http://searchworks.stanford.edu/view/666")
          end
          it "populates Comment bodies properly" do
            # body = @comment_anno.hasBody.first
            body = @comment_anno.getBody
            expect(body).to be_a LD4L::OpenAnnotationRDF::CommentBody
            expect(body.content.first).to eq @comment_value
            expect(body.type).to include(RDF::Vocab::CNT.ContentAsText)
            expect(body.type).to include(RDF::Vocab::DCMIType.Text)
          end
        end

        context "and triples represent a tag annotation" do
          before(:each) do
            @anno_url = "http://my_oa_store/TAG_ANNO"
            @tag_value = "blue"
            ttl = "<#{@anno_url}> a <http://www.w3.org/ns/oa#Annotation>;
                     <http://www.w3.org/ns/oa#hasBody> [
                       a <http://purl.org/dc/dcmitype/Text>,
                         <http://www.w3.org/2011/content#ContentAsText>,
                         <http://www.w3.org/ns/oa#Tag>;
                       <http://www.w3.org/2011/content#chars> \"#{@tag_value}\" ;
                       <http://purl.org/dc/terms/format> \"text/plain\"
                     ];
                   <http://www.w3.org/ns/oa#hasTarget> <http://searchworks.stanford.edu/view/666>;
                   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> ."

            anno_graph = RDF::Graph.new.from_ttl ttl
            r = ActiveTriples::Repositories.repositories[:default]
            r << anno_graph
            anno_uri = RDF::URI.new(@anno_url)
            @tag_anno = LD4L::OpenAnnotationRDF::Annotation.resume(anno_uri)
          end
          it "populates LD4L::OpenAnnotationRDF::TagAnnotation properly" do
            expect(@tag_anno.rdf_subject.to_s).to eq @anno_url
            expect(@tag_anno).to be_a LD4L::OpenAnnotationRDF::TagAnnotation
            expect(@tag_anno.type).to include(RDF::Vocab::OA.Annotation)
            expect(@tag_anno.motivatedBy).to include(RDF::Vocab::OA.tagging)
            expect(@tag_anno.hasTarget.first.rdf_subject).to eq RDF::URI.new("http://searchworks.stanford.edu/view/666")
          end
          it "populates Tag bodies properly" do
            # body = @tag_anno.hasBody.first
            body = @tag_anno.getBody
            expect(body).to be_a LD4L::OpenAnnotationRDF::TagBody
            expect(body.tag.first).to eq @tag_value
            expect(body.type).to include(RDF::Vocab::OA.Tag)
            expect(body.type).to include(RDF::Vocab::CNT.ContentAsText)
            expect(body.type).to include(RDF::Vocab::DCMIType.Text)
          end
        end

        context "and triples represent a semantic tag annotation" do
          before(:each) do
            @anno_url = "http://my_oa_store/SEMANTIC_TAG_ANNO"
            @term_url = "http://example.org/terms/foo"
            ttl = "<#{@anno_url}> a <http://www.w3.org/ns/oa#Annotation>;
                   <http://www.w3.org/ns/oa#hasBody> <#{@term_url}>;
                   <http://www.w3.org/ns/oa#hasTarget> <http://searchworks.stanford.edu/view/666>;
                   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#tagging> ."

            anno_graph = RDF::Graph.new.from_ttl ttl
            r = ActiveTriples::Repositories.repositories[:default]
            r << anno_graph
            anno_uri = RDF::URI.new(@anno_url)
            @semantic_tag_anno = LD4L::OpenAnnotationRDF::Annotation.resume(anno_uri)
          end
          it "populates LD4L::OpenAnnotationRDF::TagAnnotation properly" do
            expect(@semantic_tag_anno.rdf_subject.to_s).to eq @anno_url
            expect(@semantic_tag_anno).to be_a LD4L::OpenAnnotationRDF::SemanticTagAnnotation
            expect(@semantic_tag_anno.type).to include(RDF::Vocab::OA.Annotation)
            expect(@semantic_tag_anno.motivatedBy).to include(RDF::Vocab::OA.tagging)
            expect(@semantic_tag_anno.hasTarget.first.rdf_subject).to eq RDF::URI.new("http://searchworks.stanford.edu/view/666")
          end
          it "populates Tag bodies properly" do
            # body = @semantic_tag_anno.hasBody.first
            body = @semantic_tag_anno.getBody
            expect(body.rdf_subject.to_s).to eq @term_url
            expect(body).to be_a LD4L::OpenAnnotationRDF::SemanticTagBody
            expect(body.type).to include(RDF::Vocab::OA.SemanticTag)
          end
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
          subject.motivatedBy = RDF::Vocab::OA.commenting
          subject.persist!
        end

        it "should return true" do
          expect(subject).to be_persisted
        end

        context "and then modified" do
          before do
            subject.motivatedBy = RDF::Vocab::OA.tagging
          end

          it "should return true" do
            expect(subject).to be_persisted
          end
        end
        context "and then reloaded" do
          before do
            subject.reload
          end

          it "should reset the motivatedBy" do
            expect(subject.motivatedBy.first.to_s).to eq RDF::Vocab::OA.commenting.to_s
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

        subject {LD4L::OpenAnnotationRDF::Annotation.new("123")}
        let(:result) { subject.persist! }

        before do
          # Create inmemory repository
          @repo = RDF::Repository.new
          ActiveTriples::Repositories.repositories[:default] = @repo
          subject.motivatedBy = RDF::Vocab::OA.commenting
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
          expect(subject.motivatedBy.first.to_s).to eq RDF::Vocab::OA.commenting.to_s
          subject.motivatedBy = []
          expect(subject.motivatedBy).to eq []
          subject.persist!
          subject.reload
          expect(subject.annotatedAt).to eq []
          expect(@repo.statements.to_a.length).to eq 1 # Only the type statement
        end
      end
    end
  end

  describe '#destroy!' do
    before do
      subject << RDF::Statement(RDF::Vocab::DC.LicenseDocument, RDF::Vocab::DC.title, 'LICENSE')
    end

    subject { LD4L::OpenAnnotationRDF::Annotation.new('123') }

    it 'should return true' do
      expect(subject.destroy!).to be true
      expect(subject.destroy).to be true
    end

    it 'should delete the graph' do
      subject.destroy
      expect(subject).to be_empty
    end

    context 'with a parent' do
      before do
        subject.annotatedBy = child
      end

      let(:child) do
        if subject.respond_to? 'persistence_strategy'   # >= ActiveTriples 0.8
          LD4L::FoafRDF::Person.new('456',subject)
        else  # < ActiveTriples 0.8
          LD4L::FoafRDF::Person.new('456')
        end
      end

      it 'should empty the graph and remove it from the parent' do
        child.destroy
        expect(subject.annotatedBy).to be_empty
      end

      it 'should remove its whole graph from the parent' do
        child.destroy
        child.each_statement do |s|
          expect(subject.statements).not_to include s
        end
      end
    end
  end

  describe 'attributes' do
    before do
      subject.annotatedBy = annotatedBy
      subject.motivatedBy = 'commenting'
    end

    subject {LD4L::OpenAnnotationRDF::Annotation.new("123")}

    let(:annotatedBy) { LD4L::FoafRDF::Person.new('456') }

    it 'should return an attributes hash' do
      expect(subject.attributes).to be_a Hash
    end

    it 'should contain data' do
      expect(subject.attributes['motivatedBy']).to eq ['commenting']
    end

    it 'should contain child objects' do
      expect(subject.attributes['annotatedBy']).to eq [annotatedBy]
    end

    context 'with unmodeled data' do
      before do
        subject << RDF::Statement(subject.rdf_subject, RDF::Vocab::DC.contributor, 'Tove Jansson')
        subject << RDF::Statement(subject.rdf_subject, RDF::Vocab::DC.relation, RDF::URI('http://example.org/moomi'))
        node = RDF::Node.new
        subject << RDF::Statement(RDF::URI('http://example.org/moomi'), RDF::Vocab::DC.relation, node)
        subject << RDF::Statement(node, RDF::Vocab::DC.title, 'bnode')
      end

      after do
        LD4L::OpenAnnotationRDF.send(:remove_const, :Annotation)
        load 'ld4l/open_annotation_rdf/annotation.rb'
      end

      it 'should include data with URIs as attribute names' do
        expect(subject.attributes[RDF::Vocab::DC.contributor.to_s]).to eq ['Tove Jansson']
      end

      it 'should return generic Resources' do
        expect(subject.attributes[RDF::Vocab::DC.relation.to_s].first).to be_a ActiveTriples::Resource
      end

      it 'should build deep data for Resources' do
        expect(subject.attributes[RDF::Vocab::DC.relation.to_s].first.get_values(RDF::Vocab::DC.relation).
                   first.get_values(RDF::Vocab::DC.title)).to eq ['bnode']
      end

      it 'should include deep data in serializable_hash' do
        expect(subject.serializable_hash[RDF::Vocab::DC.relation.to_s].first.get_values(RDF::Vocab::DC.relation).
                   first.get_values(RDF::Vocab::DC.title)).to eq ['bnode']
      end
    end

    describe 'attribute_serialization' do
      describe '#to_json' do
        it 'should return a string with correct objects' do
          json_hash = JSON.parse(subject.to_json)
          expect(json_hash['annotatedBy'].first['id']).to eq annotatedBy.rdf_subject.to_s
        end
      end
    end
  end

  describe 'property methods' do
    it 'should set and get properties' do
      subject.motivatedBy = 'commenting'
      expect(subject.motivatedBy).to eq ['commenting']
    end
  end

  describe 'child nodes' do
    it 'should return an object of the correct class when the value is built from the base URI' do
      subject.annotatedBy = LD4L::FoafRDF::Person.new('456')
      expect(subject.annotatedBy.first).to be_kind_of LD4L::FoafRDF::Person
    end

    it 'should return an object with the correct URI created with a URI' do
      subject.annotatedBy = LD4L::FoafRDF::Person.new("http://vivo.cornell.edu/individual/JohnSmith")
      expect(subject.annotatedBy.first.rdf_subject).to eq RDF::URI("http://vivo.cornell.edu/individual/JohnSmith")
    end

    it 'should return an object of the correct class when the value is a bnode' do
      subject.annotatedBy = LD4L::FoafRDF::Person.new
      expect(subject.annotatedBy.first).to be_kind_of LD4L::FoafRDF::Person
    end
  end

  describe '#type' do
    it 'should return the type configured on the parent class' do
      expected_result = LD4L::OpenAnnotationRDF::Annotation.type.kind_of?(Array) ? LD4L::OpenAnnotationRDF::Annotation.type : [LD4L::OpenAnnotationRDF::Annotation.type]
      expect(subject.type).to eq expected_result
    end

    it 'should set the type' do
      subject.type = RDF::URI('http://example.org/AnotherClass')
      expect(subject.type).to eq [RDF::URI('http://example.org/AnotherClass')]
    end

    it 'should be the type in the graph' do
      subject.query(:subject => subject.rdf_subject, :predicate => RDF.type).statements do |s|
        expect(s.object).to eq RDF::URI('http://example.org/AnotherClass')
      end
    end
  end

  describe '#rdf_label' do
    subject {LD4L::OpenAnnotationRDF::Annotation.new("123")}

    it 'should return an array of label values' do
      expect(subject.rdf_label).to be_kind_of Array
    end

    it 'should return the default label as URI when no title property exists' do
      expect(subject.rdf_label).to eq ["#{LD4L::OpenAnnotationRDF::Annotation.base_uri}123"]
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
      subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::OA.motivatedBy, 'commenting')
      expect(subject.motivatedBy).to include 'commenting'
    end

    it 'should delete properties when statements are removed' do
      subject << RDF::Statement.new(subject.rdf_subject, RDF::Vocab::OA.motivatedBy, 'commenting')
      subject.delete RDF::Statement.new(subject.rdf_subject, RDF::Vocab::OA.motivatedBy, 'commenting')
      expect(subject.motivatedBy).to eq []
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

      LD4L::OpenAnnotationRDF::Annotation.property :item, :predicate => RDF::Vocab::DC.relation, :class_name => DummyDocument
    end

    subject { LD4L::OpenAnnotationRDF::Annotation.new }

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
      LD4L::OpenAnnotationRDF.send(:remove_const, :Annotation)
      load 'ld4l/open_annotation_rdf/annotation.rb'
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
