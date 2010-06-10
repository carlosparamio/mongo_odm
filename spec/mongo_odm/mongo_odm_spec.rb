# encoding: utf-8
require "spec_helper"

describe MongoODM do
  
  describe "included modules" do
    
  end
  
  describe "#connection" do

    context "when connection does not exist" do

      before do
        MongoODM.connection = nil
      end

      it "creates a new Mongo::Connection instance" do
        MongoODM.connection.should be_kind_of(Mongo::Connection)
      end

    end
    
    context "when connection already exists" do

      before do
        @connection = MongoODM.connection
      end

      it "returns the current Mongo::Connection instance" do
        MongoODM.connection.should == @connection
      end
      
      it "returns a different Mongo::Connection instance per thread" do
        thread = Thread.new { @connection.should_not == MongoODM.connection }
        thread.join
      end
      
      it "returns a different Mongo::Connection when configuration changes" do
        MongoODM.config = {:port => 9000}
        @connection.should_not == MongoODM.connection
      end

    end

  end

  describe "#connection=" do
    it "accepts a Mongo::Connection instance to set the connection" do
      connection = Mongo::Connection.new('localhost', 27017)
      MongoODM.connection = connection
      connection.should == MongoODM.connection
    end
  end

  describe "#config" do
    
    context "when no configuration was passed" do
      
      it "returns an empty hash" do
        MongoODM.config.should == {}
      end
      
    end
    
    context "when a custom configuration was passed" do
      
      before do
        MongoODM.config = {:host => "localhost", :port => 9000}
      end
      
      after do
        MongoODM.config = {}
      end
      
      it "should return the configuration as a hash" do
        MongoODM.config.should == {:host => "localhost", :port => 9000}
      end
      
    end
    
  end

end