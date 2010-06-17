# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::Fields do
  
  describe ".field" do
    
    context "with a name and no type" do
      
      before do
        class TestingNoType < BlankSlate; field :testing_no_type; end
      end
      
      it "adds a String field to the class" do
        TestingNoType.fields[:testing_no_type].should be_kind_of(MongoODM::Document::Fields::Field)
        TestingNoType.fields[:testing_no_type].type.should == String
      end
      
    end
    
    context "with a name and a type" do
      
      before do
        class TestingFloat < BlankSlate; field :testing_float, Float; end
      end
      
      it "adds the typed field to the class" do
        TestingFloat.fields[:testing_float].should be_kind_of(MongoODM::Document::Fields::Field)
        TestingFloat.fields[:testing_float].type.should == Float
      end
      
    end
    
  end
  
  describe ".fields" do

    context "on classes without defined fields" do
      
      it "returns an empty hash" do
        BlankSlate.fields.should == {}
      end
      
    end
    
    context "on parent classes" do
      
      it "returns a hash with the defined fields" do
        [:x, :y, :color].each do |field_name|
          Shape.fields[field_name].should be_kind_of(MongoODM::Document::Fields::Field)
        end
      end
      
      it "allows indifferent access to the hash" do
        Shape.fields[:x].should == Shape.fields["x"]
      end
      
    end
    
    context "on subclasses" do
      
      it "returns all the fields defined on the class and its subclasses" do
        [:x, :y, :radius, :color].each do |field_name|
          BigRedCircle.fields[field_name].should be_kind_of(MongoODM::Document::Fields::Field)
        end
      end
      
      it "overrides field descriptions on any parent class" do
        BigRedCircle.fields[:color].default.should == "red"
        BigRedCircle.fields[:radius].default.should == 20.0
      end
      
    end

  end
  
end

describe MongoODM::Document::Fields::Field do
  
  describe ".new" do
    
    context "with a name :testing_float and a type class Float" do
      
      before do
        @field = MongoODM::Document::Fields::Field.new(:testing_float, Float)
      end
      
      it "creates a new Field instance with name :testing_float and type Float" do
        @field.name.should == :testing_float
        @field.type.should == Float
      end
      
    end
    
    context "with a name :testing_float, a type class Float and a default option 1.0" do
      
      before do
        @field = MongoODM::Document::Fields::Field.new(:testing_float, Float, :default => 1.0)
      end
      
      it "creates a new Field instance with name :testing_float, type Float and default 1.0" do
        @field.name.should == :testing_float
        @field.type.should == Float
        @field.default.should == 1.0
      end
      
    end
    
  end
  
  describe "#default" do
  
    context "when the field described a default value" do
      
      before do
        @field = MongoODM::Document::Fields::Field.new(:color, String, :default => "red")
      end
      
      it "returns the value" do
        @field.default.should == "red"
      end
      
    end
    
    context "when the field described a block that returns the default value" do
      
      before do
        @field = MongoODM::Document::Fields::Field.new(:color, String, :default => lambda { "b" + "lue"} )
      end
      
      it "calls the block and returns the result" do
        @field.default.should == "blue"
      end
      
    end
  
  end
  
  describe "#type_cast" do
    
    context "when the field's `type' class responds to type_cast" do
      
      before do
        @field = MongoODM::Document::Fields::Field.new(:number, Integer)
      end
      
      it "returns the casted value" do
        @field.type_cast("32.3").should == 32
      end
      
    end
    
    context "when the field's `type' class do not respond to type_cast" do
      
      before do
        class InvalidClass; end
        @field = MongoODM::Document::Fields::Field.new(:invalid, InvalidClass)
      end
      
      it "raises MongoODM::Errors::TypeCastMissing" do
        lambda { @field.type_cast("whatever") }.should raise_error(MongoODM::Errors::TypeCastMissing)
      end
      
    end
    
  end
  
end