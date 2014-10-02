require 'spec_helper'

describe 'LD4L::VirtualCollectionRDF::ResourceExtension' do

  describe 'id_persisted?' do
    before(:all) do
      vc = LD4L::VirtualCollectionRDF::Collection.new('1')
      vc.persist!
    end

    context "when id is a string" do
      it "should be false if id does not exist" do
        expect(LD4L::VirtualCollectionRDF::Collection.id_persisted?('2')).to be_falsey
      end

      it "should be true if id exists" do
        expect(LD4L::VirtualCollectionRDF::Collection.id_persisted?('1')).to be_truthy
      end
    end

    context "when id is numeric" do
      it "should be false if id does not exist" do
        expect(LD4L::VirtualCollectionRDF::Collection.id_persisted?(2)).to be_falsey
      end

      it "should be true if id exists" do
        expect(LD4L::VirtualCollectionRDF::Collection.id_persisted?(1)).to be_truthy
      end
    end
  end

  describe 'uri_persisted?' do
    before(:all) do
      vc = LD4L::VirtualCollectionRDF::Collection.new('11')
      vc.persist!
    end

    context "when URI is a http string" do
      it "should be false if URI does not exist" do
        vc = LD4L::VirtualCollectionRDF::Collection.new
        test_uri = vc.get_uri('22').to_s
        expect(LD4L::VirtualCollectionRDF::Collection.uri_persisted?(test_uri)).to be_falsey
      end

      it "should be true if URI does exist" do
        vc = LD4L::VirtualCollectionRDF::Collection.new
        test_uri = vc.get_uri('11').to_s
        expect(LD4L::VirtualCollectionRDF::Collection.uri_persisted?(test_uri)).to be_truthy
      end
    end

    context "when URI is a RDF::URI" do
      it "should be false if URI does not exist" do
        vc = LD4L::VirtualCollectionRDF::Collection.new
        test_uri = vc.get_uri('22')
        expect(LD4L::VirtualCollectionRDF::Collection.uri_persisted?(test_uri)).to be_falsey
      end

      it "should be true if URI does exist" do
        vc = LD4L::VirtualCollectionRDF::Collection.new
        test_uri = vc.get_uri('11')
        expect(LD4L::VirtualCollectionRDF::Collection.uri_persisted?(test_uri)).to be_truthy
      end
    end
  end

  subject = LD4L::VirtualCollectionRDF::Collection.new

  describe "set_value" do
    it "should add a single value when none exist a priori" do
      vals = subject.get_values('aggregates')
      vals << "foo"
      subject.set_value('aggregates',vals)
      expect(subject.get_values('aggregates')).to eq ["foo"]
    end

    it "should add a single value when one value exists a priority" do
      subject.aggregates = "foo"
      vals = subject.get_values('aggregates')
      vals << "bar"
      subject.set_value('aggregates',vals)
      expect(subject.get_values('aggregates')).to eq ["foo","bar"]
    end

    it "should not change the value before calling set value" do
      subject.aggregates = "foo"
      vals = subject.get_values('aggregates')
      vals << "bar"
      expect(subject.get_values('aggregates')).to eq ["foo"]
    end
  end

end
