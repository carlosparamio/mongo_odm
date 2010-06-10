# encoding: utf-8
require "spec_helper"

describe MongoODM::Document::Fields do
  
  describe ".field" do
    
    context "with a name and no type" do
      
      before do
        BlankSlate.field(:testing_no_type)
      end
      
      after do
        BlankSlate.instance_variable_set(:@fields, nil)
      end
      
      it "adds a String field to the class" do
        BlankSlate.fields[:testing_no_type].should be_kind_of(MongoODM::Document::Fields::Field)
        BlankSlate.fields[:testing_no_type].type.should == String
      end
      
    end
    
    context "with a name and a type" do
      
      before do
        BlankSlate.field(:testing_float, Float)
      end
      
      it "adds the typed field to the class" do
        BlankSlate.fields[:testing_float].should be_kind_of(MongoODM::Document::Fields::Field)
        BlankSlate.fields[:testing_float].type.should == Float
      end
      
    end
    
  end
  
  describe ".fields" do

    context "on classes without defined fields" do
      
      before do
        @klass = BlankSlate
      end
      
      it "returns an empty hash" do
        @klass.fields.should == {}
      end
      
    end
    
    context "on parent classes" do
      
      before do
        @klass = Shape
      end
      
      it "returns a hash with the defined fields" do
        expected_fields = [:x, :y, :color]
        expected_fields.each do |field_name|
          @klass.fields[field_name].should be_kind_of(MongoODM::Document::Fields::Field)
        end
      end
      
      it "allows indifferent access to the hash" do
        @klass.fields[:x].should == @klass.fields["x"]
      end
      
    end
    
    context "on subclasses" do
      
      before do
        @klass = BigRedCircle
      end
      
      it "returns all the fields defined on the class and its subclasses" do
        expected_fields = [:x, :y, :radius, :color]
        expected_fields.each do |field_name|
          @klass.fields[field_name].should be_kind_of(MongoODM::Document::Fields::Field)
        end
      end
      
      it "overrides field descriptions on any parent class" do
        @klass.fields[:color].default.should == "red"
        @klass.fields[:radius].default.should == 20.0
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
      
      it "returns the raw value" do
        lambda { @field.type_cast("whatever") }.should raise_error(MongoODM::Errors::TypeCastMissing)
      end
      
    end
    
  end
  
end