# encoding: utf-8
require 'spec_helper'

describe MongoODM::Reference do
  class TestDocument
    include MongoODM::Document
    field :thing,  Reference # has one
    field :things, Array     # has many
  end

  before do
    @doc = TestDocument.new
    @shape = Shape.new( :color => 'red' ).save
  end

  it "refers on fields assignment" do
    @doc.thing = @shape
    @doc.thing.should be_kind_of(MongoODM::Reference)
  end

  it "#to_mongo" do
    @shape.reference.to_mongo.should == {
      '_class' => 'MongoODM::Reference',
      'collection' => 'shapes',
      'target_id' => @shape.id,
    }
  end

  it "has one" do
    @doc.thing = @shape
    @doc.save
    @doc.reload

    @doc.thing.target.should == @shape
    @doc.thing.should == @shape
    @doc.thing.color.should == @shape.color
  end

  it "has many" do
    shapes = [ @shape, Shape.new(:color => 'green').save, Shape.new(:color => 'blue').save ]
    @doc.things = shapes.map(&:reference)
    @doc.save
    @doc.reload

    @doc.things.each.with_index  do |thing, idx|
      thing.target.should == shapes[idx]
      thing.color.should == shapes[idx].color
    end
  end

  it "has many (mixed)" do
    shapes = [ @shape, Shape.new(:color => 'green').save.reference, Shape.new(:color => 'blue').save ]
    @doc.things = shapes
    @doc.save
    @doc.reload

    @doc.things[1].should be_a(Shape::Reference)
    @doc.things.each.with_index  do |thing, idx|
      thing.color.should == shapes[idx].color
    end
  end
end