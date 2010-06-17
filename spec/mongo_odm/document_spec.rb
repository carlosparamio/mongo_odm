# encoding: utf-8
require "spec_helper"

describe MongoODM::Document do
  # TODO: Test global behavior
  
  describe "#==" do
    it "returns false if the compared element is not a MongoODM::Document" do
      (Shape.new == 1).should be_false
    end
    
    it "returns true if the compared document has the same attribute values" do
      (Shape.new(:x => 2, :y => 3) == Shape.new(:x => 2, :y => 3)).should be_true
    end
    
    it "returns false if the compared document hasn't the same attribute values" do
      (Shape.new(:x => 2, :y => 3) == Shape.new(:x => 1, :y => 3)).should be_false
    end
  end
end
