# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::Referable do
  it "creates a reference" do
    klass = Class.new { include MongoODM::Document }
    klass.new.reference.should be_a(klass::Reference)
  end
end