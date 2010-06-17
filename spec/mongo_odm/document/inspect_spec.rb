# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::Inspect do
  
  describe ".inspect" do
    it "returns a string with the name of the class that includes the MongoODM::Document module and a list of its properties with types" do
      Shape.inspect.should == "Shape(x: Float, y: Float, color: String)"
    end
  end
  
  describe "#private_attribute_names" do
    it "returns ['_class']" do
      circle = Circle.new
      circle.private_attribute_names.should == ['_class']
    end
  end
  
  describe "#inspect" do
    it "returns a string with the name of the class that includes the MongoODM::Document module and a list of its attributes with values" do
      circle = Circle.new(:x => 10, :y => 12.5, :radius => 1.2)
      circle.inspect.should == "#<Circle x: 10.0, y: 12.5, color: nil, radius: 1.2>"
    end
  end
  
end