# encoding: utf-8
require "spec_helper"

describe MongoODM do
  describe "#connection" do

    context "when connection does not exist" do

      before do
        conn = Mongo::Connection.new( nil, nil, :connect => false )
        Mongo::Connection.stub(:new).and_return(conn)
        MongoODM.connection = nil
      end

      it "creates a new Mongo::Connection instance" do
        MongoODM.connection.should be_kind_of(Mongo::Connection)
      end

    end

    context "when connection already exists" do
      before do
        conn = Mongo::Connection.new( nil, nil, :connect => false )
        Mongo::Connection.stub(:new).and_return(conn)
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
        MongoODM.connection.should_not == @connection
      end

    end

  end

  describe "#connection=" do
    it "accepts a Mongo::Connection instance to set the connection" do
      connection = Mongo::Connection.new('localhost', 27017, :connect => false)
      MongoODM.connection = connection
      connection.should == MongoODM.connection
    end
  end

end