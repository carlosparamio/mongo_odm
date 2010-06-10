# encoding: utf-8
require "spec_helper"

describe "Conversions" do
  
  describe Array do

    describe ".type_cast" do

      it "returns nil when called with nil" do
        Array.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to an array" do
        Array.type_cast({:a => 1, :b => 2}).should == [[:a, 1], [:b, 2]]
        Array.type_cast([1, 2]).should == [1, 2]
      end

    end

    describe "#to_mongo" do

      it "tries to instanciate each of its elements sending MongoODM.instanciate to its classes" do
        num = 1
        float = 2.3
        string = "test"
        time = Time.now
        klass = Shape.new
        [num, float, string, time, klass].each{|i| i.should_receive(:to_mongo).once }
        [num, float, string, time, klass].to_mongo
      end
      
    end
    
  end
  
  describe Class do
    
    describe ".type_cast" do

      it "returns nil when called with nil" do
        Class.type_cast(nil).should == nil
      end
      
      it "tries to constantize to a class when called with any other value" do
        Class.type_cast("Shape").should == Shape
        Class.type_cast("Class").should == Class
      end

    end

    describe "#to_mongo" do

      it "returns the string representation of the class name" do
        Class.to_mongo.should == "Class"
        Shape.to_mongo.should == "Shape"
      end
      
    end
    
  end
  
  describe Symbol do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Symbol.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a symbol" do
        Symbol.type_cast("test").should == :test
        Symbol.type_cast([1, 2]).should == :"[1, 2]"
        Symbol.type_cast({:a => 1, :b => 2}).should == :"{:a=>1, :b=>2}"
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = :test
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe String do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        String.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a string" do
        String.type_cast(:test).should == "test"
        String.type_cast([1, 2]).should == "[1, 2]"
        String.type_cast({:a => 1, :b => 2}).should == "{:a=>1, :b=>2}"
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = "test"
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe Integer do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Integer.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to an integer" do
        Integer.type_cast(2.2).should == 2
        Integer.type_cast("23.2").should == 23
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = 2
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe Float do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Float.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a float" do
        Float.type_cast(2).should == 2.0
        Float.type_cast("23.2").should == 23.2
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = 2.23
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe BigDecimal do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        BigDecimal.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a big decimal" do
        BigDecimal.type_cast(2).should == BigDecimal.new("2")
        BigDecimal.type_cast("23.2").should == BigDecimal.new("23.2")
      end
      
    end
    
    describe "#to_mongo" do

      it "returns the string representation of the value" do
        @test = BigDecimal.new("3.14159265358979323846")
        @test.to_mongo.should == "3.14159265358979323846"
      end
      
    end
    
  end
  
  describe Date do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Date.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a date" do
        Date.type_cast("1/2/1980").should == Date.new(1980, 2, 1)
      end
      
    end
    
    describe "#to_mongo" do

      it "returns a UTC Time object for the date" do
        @test = Date.new(1980, 2, 1)
        @test.to_mongo.should == Time.utc(1980, 2, 1)
      end
      
    end
    
  end
  
  describe DateTime do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        DateTime.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a date" do
        DateTime.type_cast("1/2/1980 11:30").should == DateTime.new(1980, 2, 1, 11, 30)
      end
      
    end
    
    describe "#to_mongo" do

      it "returns a UTC Time object for the datetime" do
        @test = DateTime.new(1980, 2, 1, 11, 30)
        @test.to_mongo.should == Time.utc(1980, 2, 1, 11, 30)
      end
      
    end
    
  end
  
  describe TrueClass do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        TrueClass.type_cast(nil).should == nil
      end
      
      it "returns true when called with any other value" do
        TrueClass.type_cast(true).should == true
        TrueClass.type_cast(false).should == true
        TrueClass.type_cast(3).should == true
      end
      
    end
    
    describe "#to_mongo" do

      it "returns true" do
        true.to_mongo.should == true
      end
      
    end
    
  end
  
  describe FalseClass do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        FalseClass.type_cast(nil).should == nil
      end
      
      it "returns false when called with any other value" do
        FalseClass.type_cast(false).should == false
        FalseClass.type_cast(true).should == false
        FalseClass.type_cast(3).should == false
      end
      
    end
    
    describe "#to_mongo" do

      it "returns false" do
        false.to_mongo.should == false
      end
      
    end
    
  end
  
  describe Time do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Time.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a date" do
        Time.type_cast("1/2/1980 11:30").should == Time.utc(1980, 2, 1, 11, 30)
      end
      
    end
    
    describe "#to_mongo" do

      it "returns the time in UTC" do
        @test = Time.local(4, 56, 8, 9, 4, 2003, 3, 99, true, "CDT")
        @test.to_mongo.should == Time.utc(2003, 4, 9, 6, 56, 4)
      end
      
    end
    
  end
  
  describe Boolean do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Boolean.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to true or false" do
        Boolean.type_cast("true").should == true
        Boolean.type_cast("false").should == false
        Boolean.type_cast(15).should == true
        Boolean.type_cast(0).should == false
        Boolean.type_cast([]).should == false
        Boolean.type_cast([1]).should == true
      end
      
    end
    
  end
  
  describe Numeric do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Numeric.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a number" do
        Numeric.type_cast("23.2").should == 23.2
        Numeric.type_cast("5").should == 5
        Numeric.type_cast("any").should == 0
      end
      
    end
    
  end
  
  describe Hash do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Hash.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a hash" do
        Hash.type_cast({:a => 1}).should == {:a => 1}
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = {:a => 1}
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe Regexp do
    
    describe ".type_cast" do
      
      it "returns nil when called with nil" do
        Regexp.type_cast(nil).should == nil
      end
      
      it "tries to convert any other value to a regular expression" do
        Regexp.type_cast("^test$").should == /^test$/
      end
      
    end
    
    describe "#to_mongo" do

      it "returns itself" do
        @test = /^test$/
        @test.to_mongo.should == @test
      end
      
    end
    
  end
  
  describe NilClass do
    
    describe "#to_mongo" do
      
      it "returns nil" do
        nil.to_mongo.should == nil
      end
      
    end
    
  end
  
end