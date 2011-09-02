# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::AttributeMethods::Dirty do

  class TestDocument < Shape
    validates_presence_of :color
  end

  it "marks as dirty when changed" do
    doc = TestDocument.new :color => 'blue'
    doc.color_changed?.should == false
    doc.color = 'red'
    doc.color_changed?.should == true
  end

  it "does not mark as dirty when the same" do
    doc = TestDocument.new :color => 'blue'
    doc.color_changed?.should == false
    doc.color = 'blue'
    doc.color_changed?.should == false
  end

end