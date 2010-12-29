# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::Callbacks do

  describe "with a document" do
    it "initialize callback" do
      doc = Class.new(BlankSlate)  do
        attr_accessor :initialized
        after_initialize { |obj|  obj.initialized = true  }
      end.new
      doc.initialized.should be_true
    end

    it "save callbacks" do
      doc = Class.new(Shape)  do
        before_save :on_before_save
         after_save :on_after_save
      end.new
      doc.should_receive(:on_before_save).once.and_return(true)
      doc.should_receive(:on_after_save).once.and_return(true)
      doc.save
    end

    it "create callbacks" do
      doc = Class.new(Shape)  do
        before_create :on_before_create
         after_create :on_after_create
      end.new
      doc.should_receive(:on_before_create).once.and_return(true)
      doc.should_receive(:on_after_create).once.and_return(true)
      doc.save
    end

    it "update callbacks" do
      doc = Class.new(Shape)  do
        before_update :on_before_update
         after_update :on_after_update
      end.new
      doc.should_receive(:on_before_create).never
      doc.should_receive(:on_after_create).never
      doc.save

      doc.color = 'cyan'
      doc.should_receive(:on_before_update).once.and_return(true)
      doc.should_receive(:on_after_update).once.and_return(true)
      doc.save
    end

    it "destroy callbacks" do
      doc = Class.new(Shape)  do
        before_destroy :on_before_destroy
         after_destroy :on_after_destroy
      end.new
      doc.should_receive(:on_before_create).never
      doc.should_receive(:on_after_create).never
      doc.save

      doc.should_receive(:on_before_destroy).once.and_return(true)
      doc.should_receive(:on_after_destroy).once.and_return(true)
      doc.destroy
    end
  end

  describe "with an embedded document" do
    before do
      doc_class = Class.new(Shape)  do
        before_save :on_before_save
         after_save :on_after_save
      end
      @parent = Class.new(BlankSlate)  do
        field :thing, doc_class
      end.new
      @parent.thing = @doc = doc_class.new
    end

    it "save callbacks" do
      @doc.should_receive(:on_before_save).once.and_return(true)
      @doc.should_receive(:on_after_save).once.and_return(true)
      @parent.save
    end
  end

  describe "with an embedded array of documents" do
    before do
      doc_class = Class.new(Shape)  do
        before_save :on_before_save
         after_save :on_after_save
      end
      @parent = Class.new(BlankSlate)  do
        field :things, Array
      end.new
      @parent.things = @docs = %w{red green blue}.map { |color|  doc_class.new( :color => color )  }
    end

    it "save callbacks" do
      @docs.each  do |doc|
        doc.should_receive(:on_before_save).once.and_return(true)
        doc.should_receive(:on_after_save).once.and_return(true)
      end
      @parent.save
    end
  end
end